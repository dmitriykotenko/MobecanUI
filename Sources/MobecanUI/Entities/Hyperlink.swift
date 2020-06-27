//  Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public struct Hyperlink {
  
  public let text: NSAttributedString
  public let url: URL

  public init(text: NSAttributedString,
              url: URL) {
    self.text = text
    self.url = url
  }
}
