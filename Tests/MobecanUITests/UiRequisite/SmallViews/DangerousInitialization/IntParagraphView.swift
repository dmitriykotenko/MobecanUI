import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class FirstSummaryView: SummaryView<String, ThreeLinesLabelsGrid> {

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  required init() {
    let topLabel = UILabel()
    topLabel.font = .systemFont(ofSize: 24)
    topLabel.numberOfLines = 76

    let imageView = UIImageView()
    imageView.backgroundColor = .systemTeal

    super.init(
      iconContainer: .init(
        imageView: imageView,
        containerView: .init()
      ),
      labels: .init(
        subviews: .init(
          topLabel: topLabel,
          topRightLabel: .init(),
          middleLabel: .init(),
          bottomLabel: .init()
        ),
        spacing: .zero,
        topRightLabelInsets: .zero
      ),
      spacing: 0,
      insets: .zero
    )
  }

  override func formatValue(_ string: String?) -> Observable<IconAndTexts?> {
    .just(
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
