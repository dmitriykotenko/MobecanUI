//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class SwitchView: UIView {
  
  @RxUiInput(false) public var initialIsOn: AnyObserver<Bool>
  @RxDriverOutput(false) public var isOn: Driver<Bool>

  // Emits current value of uiSwitch every time the user toggles uiSwitch.
  var userDidChangeIsOn: Signal<Bool> {
    uiSwitch.rx.isOn.asSignal(onErrorJustReturn: false)
  }

  private let label: UILabel
  private let uiSwitch: UISwitch
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(label: UILabel,
              uiSwitch: UISwitch,
              height: CGFloat,
              spacing: CGFloat) {
    self.label = label
    self.uiSwitch = uiSwitch
    
    super.init(frame: .zero)
    
    setupHeight(height)
    addSubviews(spacing: spacing)
    setupIsOn()
  }
  
  private func setupHeight(_ height: CGFloat) {
    _ = self.height(height)
  }
  
  private func addSubviews(spacing: CGFloat) {
    putSubview(
      .hstack(
        alignment: .center,
        spacing: spacing / 2.0,
        [label, uiSwitch.fitToContent(axis: [.horizontal, .vertical])]
      )
    )
  }

  private func setupIsOn() {
    _initialIsOn
      .bind(to: uiSwitch.rx.isOn)
      .disposed(by: disposeBag)

    Observable
      .merge(_initialIsOn.asObservable(), uiSwitch.rx.isOn.asObservable())
      .bind(to: _isOn)
      .disposed(by: disposeBag)
  }
  
  public func title(_ title: String?) -> Self {
    label.text = title
    
    return self
  }
}
