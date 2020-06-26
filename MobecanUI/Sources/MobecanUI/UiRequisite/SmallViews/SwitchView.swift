//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class SwitchView: UIView {
  
  public var initialIsOn: AnyObserver<Bool> { uiSwitch.rx.isOn.asObserver() }
  public var isOn: Observable<Bool> { uiSwitch.rx.isOn.asObservable() }

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
  }
  
  private func setupHeight(_ height: CGFloat) {
    _ = self.height(height)
  }
  
  private func addSubviews(spacing: CGFloat) {
    addSingleSubview(
      .hstack(
        alignment: .center,
        spacing: spacing,
        [label, uiSwitch]
      )
    )
  }
  
  public func title(_ title: String?) -> Self {
    label.text = title
    
    return self
  }
}
