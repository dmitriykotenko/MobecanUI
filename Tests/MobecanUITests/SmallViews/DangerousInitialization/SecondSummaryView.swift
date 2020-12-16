import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class SecondSummaryView<Value>: SummaryView<Value, ThreeLinesLabelsGrid> {

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  required init() {
    let topLabel = UILabel()
    topLabel.font = .systemFont(ofSize: 16)
    topLabel.numberOfLines = 40

    let imageView = UIImageView()
    imageView.backgroundColor = .blue

    super.init(
      iconContainer: .init(
        imageView: imageView,
        containerView: .init()
      ),
      labels: .init(
        topLabel: topLabel,
        topRightLabel: .init(),
        middleLabel: .init(),
        bottomLabel: .init(),
        spacing: .zero
      ),
      spacing: 0,
      insets: .zero
    )
  }

  override func formatValue(_ value: Value?) -> Observable<IconAndTexts?> {
    let string = value.map { "\($0)" }

    return .just(
      .init(
        icon: nil,
        texts: .init(
          top: string,
          topRight: nil,
          middle: (string?.reversed()).map { String($0) },
          bottom: (string?.lowercased()).map { String($0) }
        )
      )
    )
  }
}
