import XCTest

import RxCocoa
import RxCocoaRuntime
import RxSwift
import RxTest
import SnapKit

@testable import MobecanUI


class TabBarControllerLayoutTests: XCTestCase {

  private let screenSize = CGSize(width: 320, height: 576)
  private lazy var screenBounds = CGRect(origin: .zero, size: screenSize)

  private let windowSafeAreaInsets = UIEdgeInsets(amount: 33)
  private let tabBarContentHeight: CGFloat = 70

  private func createTabBar() -> TabBar {
    TabBar(
      tabs: [
        .init(
          title: "First tab",
          icon: .singleColorImage(.systemGreen, size: .square(size: 24)),
          viewController: UIViewController()
        ),
        .init(
          title: "Second tab",
          icon: .singleColorImage(.systemOrange, size: .square(size: 24)),
          viewController: UIViewController()
        )
      ],
      backgroundView: LayoutableView(),
      initTabButton: {
        .init(
          title: $0,
          image: $1,
          textStyle: .init(alignment: .center),
          spacing: 4,
          insets: .init(amount: 10)
        )
      },
      contentHeight: tabBarContentHeight
    )
  }

  func testTabBarLayout() {
    let tabBar = createTabBar()

    let tabBarController = TabBarController(
      tabBar: tabBar,
      backgroundColor: .systemRed
    )

    let window = TestableWindow(frame: screenBounds)

    add(tabBarController: tabBarController, to: window)
    layoutTabBarController(tabBarController)

    checkTabBarFrame(tabBarController: tabBarController, tabBar: tabBar)
    checkRadioButtonFrame(tabBarController: tabBarController, tabBar: tabBar)
  }

  private func add(tabBarController: TabBarController,
                   to window: UIWindow) {
    tabBarController.view.frame = window.bounds
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
  }

  private func layoutTabBarController(_ tabBarController: TabBarController) {
    tabBarController.viewWillLayoutSubviews()
    tabBarController.view.forceLayoutSubviews()
    tabBarController.viewDidLayoutSubviews()
  }

  private func checkTabBarFrame(tabBarController: TabBarController,
                                tabBar: TabBar) {
    let expectedTabBarHeight = tabBarContentHeight + windowSafeAreaInsets.bottom

    let expectedTabBarFrame = CGRect(
      x: 0,
      y: tabBarController.view.frame.height - expectedTabBarHeight,
      width: tabBarController.view.frame.width,
      height: expectedTabBarHeight
    )

    let actualTabBarFrame = tabBar.convert(
      tabBar.bounds,
      to: tabBarController.view
    )

    XCTAssertEqual(
      actualTabBarFrame,
      expectedTabBarFrame,
      "Wrong tab bar placement"
    )
  }

  private func checkRadioButtonFrame(tabBarController: TabBarController,
                                     tabBar: TabBar) {
    let radioButton = tabBar.subviews.compactMap { $0 as? RadioButton<Tab> }.first

    if radioButton == nil {
      XCTFail("Tab bar must have at least one subview of type RadioButton<Tab>")
    }

    let expectedTabBarWidth = tabBarController.view.frame.width

    let expectedRadioButtonFrame = CGRect(
      x: windowSafeAreaInsets.left,
      y: 0,
      width: expectedTabBarWidth - (windowSafeAreaInsets.left + windowSafeAreaInsets.right),
      height: tabBarContentHeight
    )

    radioButton.map {
      XCTAssertEqual(
        $0.frame,
        expectedRadioButtonFrame,
        "Wrong tab bar's radio button placement"
      )
    }
  }

//  static var allTests = [
//  ]
}


private class TestableWindow: UIWindow {

  override var safeAreaInsets: UIEdgeInsets { .init(amount: 33) }
}


private extension UIView {

  func forceLayoutSubviews() {
    layoutIfNeeded()
    subviews.forEach { $0.forceLayoutSubviews() }
  }
}
