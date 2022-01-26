//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


// swiftlint:disable large_tuple
public class MultiButton<Value: Equatable, Button: UIButton, Action: Equatable>: LayoutableView, TypedButton {

  @RxUiInput(nil) public var value: AnyObserver<Value?>
  
  var buttons: [(Value, Button, Action)]

  public var tap: Observable<Action> {
    Observable.merge(
      buttons.map {
        let (_, button, action) = $0
        return button.rx.tap.asObservable().map { action }
      }
    )
  }
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(_ buttons: [(Value, Button, Action)],
              insets: UIEdgeInsets = .zero) {
    self.buttons = buttons
    
    super.init()
    
    setupLayout(insets: insets)
    setupButtonVisibilities()
  }
  
  private func setupLayout(insets: UIEdgeInsets) {
    layout = InsetLayout<UIView>.fromSingleSubview(
      .hstack(buttons.map(\.1)),
      insets: insets
    )
  }
  
  private func setupButtonVisibilities() {
    for (value, button, _) in buttons {
      disposeBag {
        _value.isEqual(to: value) ==> button.rx.isVisible
      }
    }
  }
}
