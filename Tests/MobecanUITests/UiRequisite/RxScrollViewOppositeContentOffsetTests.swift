import XCTest

import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit

@testable import MobecanUI


class RxScrollViewOppositeContentOffsetTests: XCTestCase {

  private struct TestMembers {

    var scrollView: UIScrollView
    var scrollViewDelegate: ScrollViewDelegate
    var contentHeightConstraint: Constraint?
  }

  func testInitialValue() {
    testTiming(
      Void.self,
      events: [],
      listener: { _, _ in },
      expectedTimes: [0]
    )
  }

  func testScrolling() {
    testTiming(
      events: [
        .next(11, CGPoint(x: 200, y: 100)),
        .next(22, CGPoint(x: 200, y: 90)),
        .next(55, CGPoint(x: 200, y: 500))
      ],
      listener: { scrollOffset, testMembers in
        testMembers.scrollView.contentOffset = scrollOffset
      },
      expectedTimes: [0, 11, 22, 55]
    )
  }

  func testContentSizeChange() {
    testTiming(
      events: [
        .next(10, CGSize(width: 200, height: 100)),
        .next(20, CGSize(width: 200, height: 90)),
        .next(25, CGSize(width: 200, height: 500))
      ],
      listener: { contentSize, testMembers in
        testMembers.contentHeightConstraint?.update(offset: contentSize.height)
        testMembers.scrollView.setNeedsLayout()
        testMembers.scrollView.layoutIfNeeded()
      },
      expectedTimes: [0, 10, 20, 25]
    )
  }

  func testAdjustedContentInsetChange() {
    testTiming(
      events: [
        .next(0, UIEdgeInsets.zero),
        .next(10, UIEdgeInsets(amount: 50)),
        .next(20, UIEdgeInsets(amount: 20)),
        .next(25, UIEdgeInsets(top: 20, left: 20, bottom: 2000, right: 55)),
        .next(30, UIEdgeInsets(amount: 80)),
        .next(50, UIEdgeInsets(top: 15, left: 3, bottom: 2000, right: 55))
      ],
      listener: { contentInset, testMembers in
        testMembers.scrollView.contentInset = contentInset
        testMembers.scrollView.layoutIfNeeded()
      },
      expectedTimes: [0, 10, 20, 25, 30, 50]
    )
  }

  private func testTiming<Element>(_ elementType: Element.Type = Element.self,
                                   events: [Recorded<Event<Element>>],
                                   listener: @escaping (Element, TestMembers) -> Void,
                                   expectedTimes: [TestTime]) {
    let testMembers = createTestMembers()
    let oppositeOffset = RxScrollViewOppositeContentOffset(
      scrollView: testMembers.scrollView,
      adjustedContentInsetDidChange: testMembers.scrollViewDelegate.adjustedContentInsetDidChange
    )

    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()

    disposeBag {
      scheduler.createHotObservable(events) ==> { listener($0, testMembers) }
    }

    let oppositeOffsetListener = scheduler.createObserver(CGPoint.self)

    disposeBag {
      oppositeOffset.value
        .debug("opposite-offset")
        ==> oppositeOffsetListener
    }

    scheduler.start()

    XCTAssertEqual(
      oppositeOffsetListener.events.compactMap { $0.time },
      expectedTimes
    )
  }

  private func createTestMembers() -> TestMembers {
    let scrollViewWidth: CGFloat = 200

    let scrollView = UIScrollView(
      frame: .init(
        x: 0,
        y: 0,
        width: scrollViewWidth,
        height: 300
      )
    )

    let scrollViewContent = UIView()
    scrollViewContent.disableTemporaryConstraints()

    var contentHeightConstraint: Constraint?
    scrollViewContent.snp.makeConstraints {
      $0.width.equalTo(scrollViewWidth)
      contentHeightConstraint = $0.height.equalTo(400).constraint
    }

    scrollView.putSingleSubview(scrollViewContent)
    scrollView.setNeedsLayout()
    scrollView.layoutIfNeeded()

    let scrollViewDelegate = ScrollViewDelegate()
    scrollView.delegate = scrollViewDelegate

    return .init(
      scrollView: scrollView,
      scrollViewDelegate: scrollViewDelegate,
      contentHeightConstraint: contentHeightConstraint
    )
  }

  static var allTests = [
    ("Test initial value", testInitialValue),
    ("Test reaction on scrolling", testScrolling),
    ("Test reaction on content size changes", testContentSizeChange),
    ("Test reaction on adjusted content inset changes", testAdjustedContentInsetChange)
  ]
}


private class ScrollViewDelegate: NSObject, UIScrollViewDelegate {

  @RxOutput(()) var adjustedContentInsetDidChange: Observable<Void>

  func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    _adjustedContentInsetDidChange.onNext(())
  }
}
