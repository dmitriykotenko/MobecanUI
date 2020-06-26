//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension ParagraphView {
  
  func title(_ title: String?) -> Self {
    self.title.onNext(title)
    return self
  }

  func body(_ body: Value?) -> Self {
    self.body.onNext(body)
    return self
  }
  
  func attributedTitle(_ attributedTitle: NSAttributedString?) -> Self {
    self.attributedTitle.onNext(attributedTitle)
    return self
  }
}
