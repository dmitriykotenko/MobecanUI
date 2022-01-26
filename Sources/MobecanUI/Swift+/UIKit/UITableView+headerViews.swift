// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UITableView {

  func register<HeaderView: UITableViewHeaderFooterView>(_ type: HeaderView.Type) {
    register(HeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewIdentifier(HeaderView.self))
  }
  
  func dequeue<HeaderView: UITableViewHeaderFooterView>(_ type: HeaderView.Type) -> HeaderView {
    let untypedHeaderView = dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier(HeaderView.self))
    
    if let headerView = untypedHeaderView as? HeaderView {
      return headerView
    } else {
      fatalError("Can not dequeue header view for \(HeaderView.self).")
    }
  }
  
  private func headerViewIdentifier<HeaderView: UITableViewHeaderFooterView>(_ type: HeaderView.Type) -> String {
    String(describing: HeaderView.self)
  }
}
