//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime
import UIKit


public extension SimpleTableViewDriver
where Element: ViewRepresentable, Element.ContentView.ViewEvent == CellEvent {
  
  private typealias ElementCell = WrapperCell<Element, Element.ContentView>

  convenience init(tableView: UITableView,
                   initElementView: @escaping () -> Element.ContentView = { Element.ContentView() },
                   spacing: CGFloat,
                   automaticReloading: Bool = true) {
    self.init(
      tableView: tableView,
      spacing: spacing,
      registerCells: { tableView in
        tableView.register(ElementCell.self)
      },
      cellAndEvents: { tableView, element, relativePosition in
        let cell = tableView.dequeue(ElementCell.self)
        cell.initMainSubview = initElementView
        
        cell.displayValue(element)
        cell.relativePosition.onNext(relativePosition)

        return (cell, cell.viewEvents)
      },
      automaticReloading: automaticReloading
    )
  }
}


public extension SimpleTableViewDriver
where Element: ViewRepresentable, Element.ContentView: TemporalView, Element.ContentView.ViewEvent == CellEvent {
  
  convenience init(tableView: UITableView,
                   spacing: CGFloat,
                   clock: Clock,
                   automaticReloading: Bool = true) {
    self.init(
      tableView: tableView,
      spacing: spacing,
      registerCells: { tableView in
        tableView.register(ElementCell.self)
    },
      cellAndEvents: { tableView, element, relativePosition in
        let cell = tableView.dequeue(ElementCell.self)
        
        cell.displayValue(element)
        cell.relativePosition.onNext(relativePosition)
        cell.clock.onNext(clock)
        
        return (cell, cell.viewEvents)
    },
      automaticReloading: automaticReloading
    )
  }
}
