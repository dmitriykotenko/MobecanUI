import XCTest

import LayoutKit
import RxSwift
import RxTest

@testable import MobecanUI


class ActionsViewLayoutTester: XCTestCase {

  private let inaccuracy: CGFloat = 0.5

  func assert<Subview: UIView>(test: Test,
                               subview: (Test) -> Subview,
                               expectedAbsoluteMinX: CGFloat? = nil,
                               expectedAbsoluteMinY: CGFloat? = nil,
                               expectedAbsoluteMaxX: CGFloat? = nil,
                               expectedAbsoluteMaxY: CGFloat? = nil,
                               expectedWidth: CGFloat? = nil,
                               expectedMaximumWidth: CGFloat? = nil,
                               expectedHeight: CGFloat? = nil,
                               expectedSize: CGSize? = nil) {
    let actualSubview = subview(test)

    let absoluteFrame = actualSubview.convert(
      actualSubview.bounds,
      to: test.containerView
    )

    expectedAbsoluteMinX.map { assertEqual(absoluteFrame.minX, $0) }
    expectedAbsoluteMinY.map { assertEqual(absoluteFrame.minY, $0) }
    expectedAbsoluteMaxX.map { assertEqual(absoluteFrame.maxX, $0) }
    expectedAbsoluteMaxY.map { assertEqual(absoluteFrame.maxY, $0) }

    expectedWidth.map { assertEqual(actualSubview.frame.width, $0) }
    expectedHeight.map { assertEqual(actualSubview.frame.height, $0) }
    expectedSize.map { assertSizesAreEqual(actualSubview.frame.size, $0) }

    expectedMaximumWidth.map {
      XCTAssert(
        actualSubview.frame.width <= $0,
        "Actual width (\(actualSubview.frame.width)) must be less than \($0)."
      )
    }
  }

  func assertEqual(_ actual: CGFloat,
                   _ expected: CGFloat) {
    XCTAssert(
      abs(actual - expected) < inaccuracy,
      "Actual value \(actual) is not equal to expected value \(expected)"
    )
  }

  func assertPointsAreEqual(_ actual: CGPoint,
                            _ expected: CGPoint) {
    let maximumDifference = max(
      abs(actual.x - expected.x),
      abs(actual.y - expected.y)
    )

    XCTAssert(
       maximumDifference < inaccuracy,
      "Actual value \(actual) is not equal to expected value \(expected)"
    )
  }

  func assertSizesAreEqual(_ actual: CGSize,
                           _ expected: CGSize) {
    let maximumDifference = max(
      abs(actual.width - expected.width),
      abs(actual.height - expected.height)
    )

    XCTAssert(
      maximumDifference < inaccuracy,
      "Actual value \(actual) is not equal to expected value \(expected)"
    )
  }

  class Test {

    let screenWidth: CGFloat = 320
    let veryLargeHeight: CGFloat = 2000
    let deleteButtonWidth: CGFloat = 80
    let checkmarkSize = CGSize(width: 24, height: 24)

    let contentViewText: String
    let errorLabelInsets: UIEdgeInsets
    let errorText: String?

    let checkmarkView: CheckmarkView

    let errorLabel = UILabel().textStyle(.init(color: .systemRed))

    let deleteButton: DiverseButton

    let contentView: DataLabel

    let actionsView: ActionsView<DataLabel>

    let containerView: UIView

    private let disposeBag = DisposeBag()

    init(contentViewText: String,
         checkmarkPlacement: ActionsViewStructs.CheckmarkPlacement.Horizontal = .leading,
         errorLabelInsets: UIEdgeInsets,
         errorText: String?,
         deleteButtonHeight: CGFloat? = nil) {
      self.contentViewText = contentViewText
      self.errorLabelInsets = errorLabelInsets
      self.errorText = errorText

      checkmarkView = .testable(size: checkmarkSize)

      deleteButton = DiverseButton.delete(width: deleteButtonWidth, height: deleteButtonHeight)

      contentView = DataLabel()
        .multilined()
        .translatesAutoresizingMaskIntoConstraints(false)
        .text(contentViewText)

      actionsView = ActionsView(
        contentView: contentView,
        insets: .zero,
        errorDisplayer: .testable(
          label: errorLabel,
          labelInsets: errorLabelInsets,
          errorText: errorText
        ),
        checkboxer: .testable(
          checkmarkView: checkmarkView,
          horizontalPlacement: checkmarkPlacement
        ),
        swiper: .testable(deleteButton: deleteButton)
      )

      containerView = TestableContainerView(
        size: .init(width: screenWidth, height: veryLargeHeight)
      )

      containerView.addSubview(actionsView)

      actionsView.value.onNext(contentViewText)

      actionsView.ingredientsState.onNext(
        .init(
          selectionState: .isSelected(false),
          errorText: errorText,
          sideActions: [.delete]
        )
      )

      containerView.setNeedsLayout()
      containerView.layoutIfNeeded()
    }
  }

  class DataLabel: UILabel, DataView, EventfulView {

    var value: AnyObserver<String?> { rx.text.asObserver() }
    var viewEvents: Observable<Void> { .never() }
  }


  class TestableContainerView: UIView {

    init(size: CGSize) {
      super.init(frame: .init(origin: .zero, size: size))
    }

    required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

    override func layoutSubviews() {
      subviews.forEach {
        $0.frame = .init(origin: .zero, size: $0.sizeThatFits(self.bounds.size))
        $0.layoutSubviews()
      }
    }
  }
}


private extension ActionsViewCheckboxer {

  static func testable(
    checkmarkView: CheckmarkView,
    horizontalPlacement: ActionsViewStructs.CheckmarkPlacement.Horizontal
  ) -> ActionsViewCheckboxer {
    .init(
      initCheckmarkView: { checkmarkView },
      checkmarkPlacement: .init(
        horizontal: horizontalPlacement,
        vertical: .top(offset: 0)
      )
    )
  }
}


private extension ActionsViewErrorDisplayer {

  static func testable(label: UILabel,
                       labelInsets: UIEdgeInsets,
                       errorText: String?) -> ActionsViewErrorDisplayer {
    .init(
      initLabel: { [label] in label },
      labelInsets: labelInsets,
      displayError: { _ in
          .init(
            errorText: errorText,
            backgroundColor: .systemRed.withAlphaComponent(0.25)
          )
      }
    )
  }
}


private extension ActionsViewSwiper {

  static func testable(deleteButton: UIButton) -> ActionsViewSwiper {
    .init(
      possibleButtonsAndActions: [.delete: deleteButton],
      animationDuration: 250.milliseconds
    )
  }
}


private extension DiverseButton {

  static func delete(width: CGFloat,
                     height: CGFloat? = nil) -> DiverseButton {
    DiverseButton()
      .fixedWidth(width)
      .fixedHeight(height)
      .fitToContent(axis: [.horizontal])
  }
}


private extension CheckmarkView {

  static func testable(size: CGSize) -> CheckmarkView {
    .init(
      selectedView: UIView
        .spacer(width: size.width, height: size.height)
        .backgroundColor(.systemPurple),
      notSelectedView: UIView
        .spacer(width: size.width, height: size.height)
        .backgroundColor(.lightGray),
      horizontalInset: 0,
      verticalInset: 0
    )
  }
}
