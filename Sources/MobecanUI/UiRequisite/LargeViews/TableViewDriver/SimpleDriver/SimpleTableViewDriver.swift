// Copyright © 2020 Mobecan. All rights reserved.

import RxKeyboard
import RxSwift
import UIKit


open class SimpleTableViewDriver<Element, CellEvent>: TableViewDriver<
  Element,
  CellEvent,
  SimpleTableViewHeader?,
  Void,
  SimpleTableViewSticker,
  EquatableVoid,
  Void,
  EmptyTableViewSticker
> {

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
      topStickerEvents: { _ in .never() },
      displayFooter: spacing == 0 ? nil : { _, sticker, _ in
        sticker.height = spacing
      },
      bottomStickerEvents: { _ in .never() },
      registerCells: registerCells,
      cellAndEvents: cellAndEvents,
      automaticReloading: automaticReloading
    )
  }
}
