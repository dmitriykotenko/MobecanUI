// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIScrollView {
  
  @discardableResult
  func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
    self.isScrollEnabled = isScrollEnabled
    return self
  }
  
  @discardableResult
  func isPagingEnabled(_ isPagingEnabled: Bool) -> Self {
    self.isPagingEnabled = isPagingEnabled
    return self
  }

  @discardableResult
  func alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool) -> Self {
    self.alwaysBounceHorizontal = alwaysBounceHorizontal
    return self
  }

  @discardableResult
  func alwaysBounceVertical(_ alwaysBounceVertical: Bool) -> Self {
    self.alwaysBounceVertical = alwaysBounceVertical
    return self
  }
  
  @discardableResult
  func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> Self {
    self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    return self
  }
  
  @discardableResult
  func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> Self {
    self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
    return self
  }
  
  @discardableResult
  func contentInset(_ contentInset: UIEdgeInsets) -> Self {
    self.contentInset = contentInset
    return self
  }

  @discardableResult
  func keyboardDismissMode(_ keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> Self {
    self.keyboardDismissMode = keyboardDismissMode
    return self
  }
}
