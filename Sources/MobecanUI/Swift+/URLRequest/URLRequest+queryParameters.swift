// Copyright © 2021 Mobecan. All rights reserved.

import Foundation


public extension URLRequest {

  var queryParameters: OrderedMultiDictionary<String, String> {
    url?.query?
      .doubleSplit(outerSeparator: "&", innerSeparator: "=")
      .compactMap { $0.asPair }
      .asOrderedMultiDictionary()
      ?? [:]
  }
}
