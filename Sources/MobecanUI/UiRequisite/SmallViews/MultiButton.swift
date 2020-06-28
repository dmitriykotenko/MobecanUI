//  Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxSwift
import UIKit


// swiftlint:disable large_tuple
public class MultiButton<Value: Equatable, Button: UIButton, Action: Equatable>: UIView, TypedButton {

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
    
    super.init(frame: .zero)
    
    addSubviews(insets: insets)
    setupButtonVisibilities()
  }
  
  private func addSubviews(insets: UIEdgeInsets) {
    putSubview(
      .hstack(buttons.map { $0.1 }),
      insets: insets
    )
  }
  
  private func setupButtonVisibilities() {
    for (value, button, _) in buttons {
      _value.map { $0 == value }
        .bind(to: button.rx.isVisible)
        .disposed(by: disposeBag)
    }
  }
}
