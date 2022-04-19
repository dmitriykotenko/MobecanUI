// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit


open class SwitchView: LayoutableView {

  @RxUiInput(false) open var initialIsOn: AnyObserver<Bool>
  @RxOutput(false) open var isOn: Observable<Bool>

  // Emits current value of uiSwitch every time the user toggles uiSwitch.
  open var userDidChangeIsOn: Signal<Bool> {
    uiSwitch.rx.isOn.asSignal(onErrorJustReturn: false)
  }

  private let label: UILabel
  private let uiSwitch: UISwitch

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(label: UILabel,
              uiSwitch: UISwitch,
              layout: Layout = .spacing(0)) {
    self.label = label
    self.uiSwitch = uiSwitch

    super.init()

    setupLayout(layout)

    setupIsOn()
  }

  private func setupLayout(_ layout: Layout) {
    uiSwitch.fitToContent(axis: [.horizontal, .vertical])

    self.layout = SizeLayout<UIView>(
      minHeight: layout.minimumHeight,
      sublayout: InsetLayout(
        insets: layout.overallInsets,
        alignment: .init(
          vertical: .center,
          horizontal: .fill
        ),
        sublayout: StackLayout(
          axis: .horizontal,
          spacing: layout.spacing,
          sublayouts: [
            InsetLayout(
              insets: layout.titleInsets,
              alignment: .center,
              sublayout: BoilerplateLayout(label, alignment: .center)
            ),
            UIView.stretchableHorizontalSpacer().asLayout,
            uiSwitch.withAlignment(layout.switchPlacement.asAlignment)
          ]
        )
      )
    )
  }

  private func setupIsOn() {
    disposeBag {
      _initialIsOn ==> uiSwitch.rx.isOn

      _isOn <== .merge(_initialIsOn.asObservable(), uiSwitch.rx.isOn.asObservable())
    }
  }

  @discardableResult
  open func title(_ title: String?) -> Self {
    label.text = title
    return self
  }

  override open var forFirstBaselineLayout: UIView {
    label.forFirstBaselineLayout
  }

  override open var forLastBaselineLayout: UIView {
    label.forLastBaselineLayout
  }
}


extension SwitchView: MandatorinessListener {

  public var isMandatory: AnyObserver<Bool> {
    .fromArray(
      [label, uiSwitch].compactMap {
        ($0 as? MandatorinessListener)?.isMandatory
      }
    )
  }
}
