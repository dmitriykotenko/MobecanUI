//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension TableViewDriver
where Element: ViewRepresentable, Element.ContentView.ViewEvent == CellEvent {
  
  private typealias ElementCell = WrapperCell<Element, Element.ContentView>

  convenience init(tableView: UITableView,
                   displayHeader: ((Header, Sticker, SectionRelativePosition) -> Void)? = nil,
                   stickerEvents: ((Sticker) -> Observable<StickerEvent>)? = nil,
                   initElementView: @escaping () -> Element.ContentView = { Element.ContentView() },
                   spacing: CGFloat,
                   automaticReloading: Bool = true) {
    self.init(
      tableView: tableView,
      displayHeader: displayHeader,
      stickerEvents: stickerEvents,
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
