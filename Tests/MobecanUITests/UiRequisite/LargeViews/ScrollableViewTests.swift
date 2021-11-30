import XCTest

import LayoutKit
import RxSwift
import RxTest

@testable import MobecanUI


class ScrollableViewTests: XCTestCase {

  private let screenSize = CGSize(width: 320, height: 576)
  private lazy var screenBounds = CGRect(origin: .zero, size: screenSize)

  private let windowSafeAreaInsets = UIEdgeInsets(amount: 33)

  func testFrame() {
    let test = Test(
      contentView: UILabel()
        .multilined()
        .text(String(repeating: "Ghm... ", count: 1000))
        .fitToContent(axis: [.vertical]),
      scrollView: UIScrollView(),
      screenSize: screenSize,
      screenSafeAreaInsets: windowSafeAreaInsets,
      testCase: self
    )

    test.performLayout()

    assertRectsAreEqual(
      actual: test.scrollableView.frame,
      expected: .init(origin: .zero, size: screenSize)
    )
  }

  func testContentFrame() {
    let test = Test(
      contentView: UILabel()
        .multilined()
        .text(String(repeating: "Ghm... ", count: 1000))
        .fitToContent(axis: [.vertical]),
      scrollView: UIScrollView(),
      screenSize: screenSize,
      screenSafeAreaInsets: windowSafeAreaInsets,
      testCase: self
    )

    test.performLayout()

    let actualContentFrame = test.contentView.convert(
      test.contentView.bounds,
      to: test.scrollView
    )

    assertRectsAreEqual(
      actual: actualContentFrame,
      expected: .init(
        origin: .zero,
        size: test.expectedContentSize
      )
    )
  }

  func testScrollViewContentSize() {
    let test = Test(
      contentView: UILabel()
        .multilined()
        .text(String(repeating: "Ghm... ", count: 1000))
        .fitToContent(axis: [.vertical]),
      scrollView: UIScrollView(),
      screenSize: screenSize,
      screenSafeAreaInsets: windowSafeAreaInsets,
      testCase: self
    )

    test.performLayout()

    assertSizesAreEqual(
      actual: test.scrollView.contentSize,
      expected: test.expectedContentSize
    )
  }

  func testScrollViewContentInset() {
    let test = Test(
      contentView: UILabel()
        .multilined()
        .text(String(repeating: "Ghm... ", count: 1000))
        .fitToContent(axis: [.vertical]),
      scrollView: UIScrollView(),
      screenSize: screenSize,
      screenSafeAreaInsets: windowSafeAreaInsets,
      testCase: self
    )

    test.performLayout()

    assertInsetsAreEqual(
      actual: test.scrollView.contentInset,
      expected: windowSafeAreaInsets
    )
  }

  private class Test<ContentView: UIView> {

    var contentView: ContentView
    var scrollView: UIScrollView
    var scrollableView: ScrollableView
    var viewController: UIViewController
    var window: UIWindow

    var expectedContentSize: CGSize

    var testCase: XCTestCase

    init(contentView: ContentView,
         scrollView: UIScrollView,
         screenSize: CGSize,
         screenSafeAreaInsets: UIEdgeInsets,
         testCase: XCTestCase) {
      self.testCase = testCase

      self.contentView = contentView

      self.expectedContentSize = CGSize(
        width: screenSize.width,
        height:
          contentView
          .sizeThatFits(
            .init(width: screenSize.width, height: .greatestFiniteMagnitude)
          )
          .height
      )

      self.scrollView = scrollView

      self.scrollableView = ScrollableView(
        contentView: contentView,
        scrollView: { scrollView }
      )

      self.viewController = TestableViewController()
      viewController.view.addSubview(scrollableView)
      scrollableView.frame = viewController.view.bounds

      self.window = TestableWindow(
        frame: .init(
          origin: .zero,
          size: screenSize
        )
      )
    }

    func performLayout() {
      add(viewController: viewController, to: window)
      layoutViewController(viewController)

      let layoutExpectation = testCase.expectation(description: "Layout did finish")

      // Wait until every asynchronous layout update finishes.
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        layoutExpectation.fulfill()
      }

      testCase.waitForExpectations(timeout: 20, handler: nil)
    }

    private func add(viewController: UIViewController,
                     to window: UIWindow) {
      viewController.view.frame = window.bounds
      window.rootViewController = viewController
      window.makeKeyAndVisible()
    }

    private func layoutViewController(_ viewController: UIViewController) {
      viewController.viewWillLayoutSubviews()
      viewController.view.forceLayoutSubviews()
      viewController.viewDidLayoutSubviews()
    }
  }

  private func assertSizesAreEqual(actual: CGSize,
                                   expected: CGSize) {
    let maximum = max(
      abs(actual.width - expected.width),
      abs(actual.height - expected.height)
    )

    let inaccuracy: CGFloat = 0.5

    if maximum >= inaccuracy {
      XCTFail("Actual size \(actual) is too different from expected size \(expected)")
    }
  }

  private func assertRectsAreEqual(actual: CGRect,
                                   expected: CGRect) {
    let maximum = max(
      abs(actual.minX - expected.minX),
      abs(actual.minY - expected.minY),
      abs(actual.maxX - expected.maxX),
      abs(actual.maxY - expected.maxY)
    )

    let inaccuracy: CGFloat = 0.5

    if maximum >= inaccuracy {
      XCTFail("Actual rect \(actual) is too different from expected rect \(expected)")
    }
  }

  private func assertInsetsAreEqual(actual: UIEdgeInsets,
                                    expected: UIEdgeInsets) {
    let maximum = max(
      abs(actual.top - expected.top),
      abs(actual.bottom - expected.bottom),
      abs(actual.left - expected.left),
      abs(actual.right - expected.right)
    )

    let inaccuracy: CGFloat = 0.5

    if maximum >= inaccuracy {
      XCTFail("Actual edge insets \(actual) is too different from expected edge insets \(expected)")
    }
  }

  static var allTests = [
    ("Test scrollable view frame", testFrame),
    ("Test content view frame", testContentFrame),
    ("Test scroll view content size", testScrollViewContentSize),
    ("Test scroll view content inset", testScrollViewContentInset),
  ]
}


private class TestableWindow: UIWindow {

  override var safeAreaInsets: UIEdgeInsets { .init(amount: 33) }
}


private extension UIView {

  func forceLayoutSubviews() {
    layoutSubviews()
    subviews.forEach { $0.forceLayoutSubviews() }
  }
}


private class TestableContentView: UIView {

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return size
  }
}


private class TestableViewController: UIViewController {

  override func loadView() {
    view = SingleSubviewContainer()
  }
}


private class SingleSubviewContainer: UIView {

  override func layoutSubviews() {
    subviews.forEach { $0.frame = bounds }
  }
}
