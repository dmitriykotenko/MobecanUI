import XCTest

@testable import MobecanUI


final class DecimalRandomGenerationTests: XCTestCase {

  func test() {
    let decimals = (1...10_000).map { _ in Decimal.random }

    XCTAssert(decimals.contains { $0 < 0 })
    XCTAssert(decimals.contains { $0 > 0 })
  }
}
