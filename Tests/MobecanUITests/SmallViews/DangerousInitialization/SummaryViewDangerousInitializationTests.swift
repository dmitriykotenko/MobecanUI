import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class SummaryViewDangerousInitializationTests: XCTestCase {

  func testThatParameterlessInitializerDoesNotCrash() {
    let _: SummaryView<Int, ThreeLinesLabelsGrid> = dangerousInit()
  }

  func testThatSubclassParameterlessInitializerDoesNotCrash() {
    let _: FirstSummaryView = dangerousInit()
  }

  func testGenericSubclassParameterlessInitializer() {
    let _: SecondSummaryView<CGFloat> = dangerousInit()
  }

  private func dangerousInit<View: UIView>() -> View { View() }

  static var allTests = [
    ("Test parameterless initializer", testThatParameterlessInitializerDoesNotCrash),
    ("Test subclass' parameterless initializer", testThatSubclassParameterlessInitializerDoesNotCrash),
    ("Test generic subclass' parameterless initializer", testGenericSubclassParameterlessInitializer)
  ]
}
