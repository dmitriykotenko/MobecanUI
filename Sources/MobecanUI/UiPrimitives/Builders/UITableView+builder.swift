// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UITableView {

  @discardableResult
  func separatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
    self.separatorStyle = separatorStyle
    return self
  }
}
