//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIScrollView {
  
  func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
    self.isScrollEnabled = isScrollEnabled
    return self
  }
  
  func isPagingEnabled(_ isPagingEnabled: Bool) -> Self {
    self.isPagingEnabled = isPagingEnabled
    return self
  }

  func alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool) -> Self {
    self.alwaysBounceHorizontal = alwaysBounceHorizontal
    return self
  }

  func alwaysBounceVertical(_ alwaysBounceVertical: Bool) -> Self {
    self.alwaysBounceVertical = alwaysBounceVertical
    return self
  }
  
  func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> Self {
    self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
    return self
  }
  
  func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> Self {
    self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
    return self
  }
  
  func contentInset(_ contentInset: UIEdgeInsets) -> Self {
    self.contentInset = contentInset
    return self
  }

  func keyboardDismissMode(_ keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> Self {
    self.keyboardDismissMode = keyboardDismissMode
    return self
  }
}
