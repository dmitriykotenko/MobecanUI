//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class SwitchView: UIView {

  @RxUiInput(false) public var initialIsOn: AnyObserver<Bool>
  @RxOutput(false) public var isOn: Observable<Bool>

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
              layout: Layout = .spacing(0)) {
    self.label = label
    self.uiSwitch = uiSwitch

    super.init(frame: .zero)

    addSubviews(layout: layout)

    setupIsOn()
  }

  private func addSubviews(layout: Layout) {
    putSubview(
      .hstack(spacing: layout.spacing, [
        UIView
          .centeredVertically(label)
          .hugSubviews(axis: .vertical, priority: layout.contentHuggingPriority)
          .withInsets(layout.titleInsets),
        switchContainer(layout: layout)
      ]),
      insets: layout.overallInsets
    )
  }

  private func switchContainer(layout: Layout) -> UIView {
    _ = uiSwitch.fitToContent(axis: [.horizontal, .vertical])

    switch layout.switchPlacement {
    case .top(let inset):
      return .top(uiSwitch, inset: inset)
    case .center(let offset):
      return .centeredVertically(uiSwitch, offset: offset)
    case .bottom(let inset):
      return .bottom(uiSwitch, inset: inset)
    case .centerOrTop(let thresholdHeight):
      let container = UIView.spacer()

      container.addSubview(uiSwitch)

      uiSwitch.snp.makeConstraints {
        $0.centerY.equalToSuperview().priority(layout.contentHuggingPriority.advanced(by: -1))
        $0.centerY.lessThanOrEqualTo(thresholdHeight / 2.0)
      }

      return container
    }
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


private extension UIView {

  func hugSubviews(axis: NSLayoutConstraint.Axis,
                   priority: ConstraintPriority) -> Self {
    subviews.forEach {
      $0.snp.makeConstraints {
        switch axis {
        case .horizontal:
          $0.leading.lessThanOrEqualToSuperview().priority(priority)
          $0.trailing.greaterThanOrEqualToSuperview().priority(priority)
        case .vertical:
          $0.top.lessThanOrEqualToSuperview().priority(priority)
          $0.bottom.greaterThanOrEqualToSuperview().priority(priority)
        @unknown default:
          fatalError("NSLayoutConstraint.Axis \(axis) is not supported yet.")
        }
      }
    }

    return self
  }
}
