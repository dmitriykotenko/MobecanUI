import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class ParagraphViewDangerousInitializationTests: XCTestCase {

  func testThatParameterlessInitializerDoesNotCrash() {
    let _: ParagraphView<String, Never> = dangerousInit()
  }

  func testThatSubclassParameterlessInitializerDoesNotCrash() {
    let _: IntParagraphView = dangerousInit()
  }

  private func dangerousInit<View: UIView>() -> View { View() }

  static var allTests = [
    ("Test parameterless initializer", testThatParameterlessInitializerDoesNotCrash),
    ("Test subclass' parameterless initializer", testThatSubclassParameterlessInitializerDoesNotCrash)
  ]
}
