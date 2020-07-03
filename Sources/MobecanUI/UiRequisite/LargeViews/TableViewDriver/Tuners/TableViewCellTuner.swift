//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


class TableViewCellTuner<Element, Event> {
  
  typealias CellAndEvents =
    (UITableView, Element, RowRelativePosition) -> (UITableViewCell, Observable<Event>)

  private let tableView: UITableView
  private let cellAndEvents: CellAndEvents
  
  init(tableView: UITableView,
       registerCells: (UITableView) -> Void,
       cellAndEvents: @escaping CellAndEvents) {
    self.tableView = tableView
    self.cellAndEvents = cellAndEvents
    
    registerCells(tableView)
    setupAutomaticDimensioning()
  }
  
  private func setupAutomaticDimensioning() {
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
  }
  
  func cellAndEvents(element: Element,
                     relativePosition: RowRelativePosition) -> (UITableViewCell, Observable<Event>) {

    cellAndEvents(tableView, element, relativePosition)
  }
}
