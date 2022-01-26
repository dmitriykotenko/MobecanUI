// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIScrollView {

  func scrollToBottom(animated: Bool) {
    setContentOffset(
      CGPoint(
        x: 0,
        y: contentSize.height - bounds.size.height + contentInset.bottom
      ),
      animated: animated
    )
  }
}
