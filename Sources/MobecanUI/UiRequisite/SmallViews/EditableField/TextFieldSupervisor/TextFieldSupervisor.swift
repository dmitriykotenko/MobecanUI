//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public class TextFieldSupervisor<Value>: LayoutableControl, UITextFieldDelegate {
  
  @RxUiInput(nil) public var initialValue: AnyObserver<Value?>
  @RxOutput(nil) public var value: Observable<Value?>
  
  public let textField: UITextField
  
  private let customKeyboard: UIView
  private let keyboardAccessoryView: UIView
  private let formatter: (Value) -> String
  private let valueGetter: Observable<Value>
  private let valueSetter: AnyObserver<Value>
  
  private let autoappearingValue: Observable<Value?>
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(textField: UITextField,
              keyboard: UIView,
              keyboardAccessoryView: UIView,
              formatter: @escaping (Value) -> String,
              value: ControlProperty<Value>,
              autoappearingValue: Value? = nil) {
    self.textField = textField
    self.customKeyboard = keyboard
    self.keyboardAccessoryView = keyboardAccessoryView
    self.formatter = formatter
    self.valueGetter = value.asObservable()
    self.valueSetter = value.asObserver()
    
    self.autoappearingValue =
      textField.rx.editingDidBegin.asObservable()
        .compactMap { autoappearingValue }
    
    super.init()

    layout = textField.asLayout
      .withInsets(.zero) // ensure that layout's main view is not a text field

    setupTextField()
    setupOutput()
    
    setupClearButton()
  }
  
  private func setupTextField() {
    textField.inputView = customKeyboard
    textField.inputAccessoryView = keyboardAccessoryView
  }
  
  private func setupOutput() {
    disposeBag {
      Observable
        .merge(_initialValue.asObservable(), autoappearingValue)
        .filterNil() ==> valueSetter
    }

    let currentValue = Observable.merge(
      _initialValue.asObservable(),
      autoappearingValue.filterWith(value.map { $0 == nil }),
      valueGetter.map { $0 }
    )

    disposeBag {
      currentValue ==> _value
    
      value.nestedMap { [formatter] in formatter($0) } ==> textField.rx.text
    }
  }
  
  private func setupClearButton() {
    textField.delegate = self
  }
  
  public func textFieldShouldClear(_ textField: UITextField) -> Bool {
    _value.onNext(nil)
    return true
  }
  
  @objc
  public func closeKeyboard() {
    textField.resignFirstResponder()
  }
}
