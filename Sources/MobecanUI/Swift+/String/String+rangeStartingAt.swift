// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension String {

  func range<SomeString: StringProtocol>(of substring: SomeString,
                                         onlyAfter searchStartIndex: Index? = nil,
                                         onlyBefore searchEndIndex: Index? = nil,
                                         options: String.CompareOptions = [],
                                         locale: Locale? = nil) -> Range<Index>? {
    range(
      of: substring,
      options: options,
      range: (searchStartIndex ?? startIndex)..<(searchEndIndex ?? endIndex),
      locale: locale
    )
  }
}
