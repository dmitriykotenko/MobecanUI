// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension ParagraphView {
  
  @discardableResult
  func title(_ title: String?) -> Self {
    self.title.onNext(title)
    return self
  }

  @discardableResult
  func body(_ body: Value?) -> Self {
    self.body.onNext(body)
    return self
  }
  
  @discardableResult
  func attributedTitle(_ attributedTitle: NSAttributedString?) -> Self {
    self.attributedTitle.onNext(attributedTitle)
    return self
  }
}
