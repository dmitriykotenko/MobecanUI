// Copyright © 2024 Mobecan. All rights reserved.

import XCTest

import RxCocoa
import RxSwift

@testable import MobecanUI


extension ArrayDeserializationTests {

  func testTopLevelNull() {
    check(
      deserializedType: [Match].self,
      jsonString: "null",
      expectedDecodingError: .valueNotFound(
        expectedType: .init(type: [Any].self),
        context: .init(
          codingPath: [],
          debugDescription: "Cannot get unkeyed decoding container -- found null value instead",
          underlyingError: nil
        )
      )
    )
  }
}
