// Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxGesture
import RxSwift
import UIKit


public class PictogramInputField: UIView {
  
  public var text: ControlProperty<String?> { textField.rx.text }
  
  private let pictogramsContainer = UIView()
  private let textField = InvisibleTextField()
  
  private let label: PictogramLabel
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(label: PictogramLabel,
              keyboard: UIKeyboardType,
              textContentType: UITextContentType? = nil,
              validation: TextFieldValidation) {
    self.label = label
    
    super.init(frame: .zero)
    
    addSubviews()
    
    setupTextField(
      keyboard: keyboard,
      textContentType: textContentType,
      validation: validation
    )
    
    setupTaps()
  }
  
  private func addSubviews() {
    putSubview(
      .zstack([
        .centered(textField),
        label
      ])
    )
  }
  
  private func setupTextField(keyboard: UIKeyboardType,
                              textContentType: UITextContentType?,
                              validation: TextFieldValidation) {
    textField.isHidden = true
    textField.keyboardType = keyboard
    textField.textContentType = textContentType
    
    textField.setValidation(validation)

    disposeBag {
      textField.rx.text ==> label.text
    }
  }

  private func setupTaps() {
    disposeBag {
      rx.tapGesture()
        .when(.recognized)
        ==> { [weak self] _ in self?.textField.becomeFirstResponder() }
    }
  }
}


private class InvisibleTextField: MaskedTextField {
  
  override func canPerformAction(_ action: Selector,
                                 withSender sender: Any?) -> Bool {
    false
  }
}
