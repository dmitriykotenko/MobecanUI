//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


class TableViewShaker {

  private let tableView: UITableView
  
  init(_ tableView: UITableView) {
    self.tableView = tableView
  }
  
  func performShakes(_ shakes: [TableViewShake]) {
    // TODO: preserve position of currently visible element even if its index path has changed
    if shakes.count == 1 {
      performShake(shakes[0])
    } else {
      tableView.beginUpdates()
      shakes.forEach(performShake)
      tableView.endUpdates()
    }
  }
  
  private func performShake(_ shake: TableViewShake) {
    switch shake {
    case .reloadData: tableView.reloadData()
    case .insertSection(let index): tableView.insertSections([index], with: .automatic)
    case .reloadSection(let index): tableView.reloadSections([index], with: .automatic)
    case .deleteSection(let index): tableView.deleteSections([index], with: .automatic)
    
    case .insertRows(let rows, let section):
      tableView.insertRows(at: rows.map { IndexPath(row: $0, section: section) }, with: .automatic)
    case .deleteRows(let rows, let section):
      tableView.deleteRows(at: rows.map { IndexPath(row: $0, section: section) }, with: .automatic)
    }
  }
}
