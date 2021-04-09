//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension Array where Element: NSAttributedString {

  func mkAttributedString(start: NSAttributedString? = nil,
                          end: NSAttributedString? = nil) -> NSAttributedString {
    mkAttributedString(
      start: start,
      separator: .plain("\n"),
      end: end
    )
  }

  func mkAttributedString(start: NSAttributedString? = nil,
                          separator: NSAttributedString? = nil,
                          end: NSAttributedString? = nil) -> NSAttributedString {
    let result = NSMutableAttributedString()

    start.map { result.append($0) }

    dropLast().forEach {
      result.append($0)
      separator.map { result.append($0) }
    }

    last.map { result.append($0) }

    end.map { result.append($0) }

    return NSAttributedString(attributedString: result)
  }
}
