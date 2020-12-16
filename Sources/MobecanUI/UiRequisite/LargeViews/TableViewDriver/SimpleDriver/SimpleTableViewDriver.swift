//  Copyright © 2020 Mobecan. All rights reserved.

import RxKeyboard
import RxSwift
import UIKit


open class SimpleTableViewDriver<Element, CellEvent>: TableViewDriver<
  SimpleTableViewHeader?,
  Element,
  Void,
  CellEvent,
  SimpleTableViewSticker> {

  public init(tableView: UITableView,
              stickerSettings: SimpleTableViewSticker.TextSettings = .defaultTextSettings,
              spacing: CGFloat,
              registerCells: @escaping (UITableView) -> Void,
              cellAndEvents: @escaping CellAndEvents,
              automaticReloading: Bool = true) {
    super.init(
      tableView: tableView,
      displayHeader: { header, sticker, _ in
        sticker.textSettings = stickerSettings
        sticker.displayValue(header)
      },
      stickerEvents: { _ in .never() },
      spacing: spacing,
      registerCells: registerCells,
      cellAndEvents: cellAndEvents,
      automaticReloading: automaticReloading
    )
  }
}
