// Copyright © 2020 Mobecan. All rights reserved.

import Foundation
import NonEmpty


@TryInit
public struct Hyperlink: Equatable, Hashable, Lensable {
  
  public var text: NSAttributedString
  public var url: URL

  public init(text: NSAttributedString,
              url: URL) {
    self.text = text
    self.url = url
  }
}
