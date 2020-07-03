//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UITableView {

  func register<Cell: UITableViewCell>(_ type: Cell.Type) {
    register(Cell.self, forCellReuseIdentifier: cellIdentifier(Cell.self))
  }
  
  func dequeue<Cell: UITableViewCell>(_ type: Cell.Type) -> Cell {
    if let cell = dequeueReusableCell(withIdentifier: cellIdentifier(Cell.self)) as? Cell {
      return cell
    } else {
      fatalError("Can not dequeue cell for \(Cell.self).")
    }
  }
  
  private func cellIdentifier<Cell: UITableViewCell>(_ type: Cell.Type) -> String {
    String(describing: Cell.self)
  }
}
