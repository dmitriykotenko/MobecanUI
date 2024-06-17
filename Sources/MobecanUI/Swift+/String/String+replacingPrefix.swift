// Copyright © 2024 Mobecan. All rights reserved.

import Foundation


public extension String {

  /// Если строка начинается с указанного префикса, заменяет его другим.
  func replacing<OldPrefix: StringProtocol, NewPrefix: StringProtocol>(
    prefix: OldPrefix,
    by newPrefix: NewPrefix
  ) -> String {
    starts(with: prefix) ? dropFirst(prefix.count).asString : self
  }
}
