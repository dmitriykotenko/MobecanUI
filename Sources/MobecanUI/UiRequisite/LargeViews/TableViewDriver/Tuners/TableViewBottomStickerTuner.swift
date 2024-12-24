// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift
import UIKit


class TableViewBottomStickerTuner<Footer, Sticker: UITableViewHeaderFooterView & HeightAwareView, Event>
where Sticker.Value == Footer {
  
  private var tableView: UITableView
  private var displayFooter: ((Footer, Sticker, SectionRelativePosition) -> Void)?
  private var stickerEvents: ((Sticker) -> Observable<Event>)?
  
  private lazy var sampleSticker = Sticker(reuseIdentifier: "")

  init(tableView: UITableView,
       displayFooter: ((Footer, Sticker, SectionRelativePosition) -> Void)?,
       stickerEvents: ((Sticker) -> Observable<Event>)?) {
    
    self.tableView = tableView
    self.displayFooter = displayFooter
    self.stickerEvents = stickerEvents

    registerSticker()
    setupAutomaticDimensioning()
  }
  
  private func registerSticker() {
    // Если displayFooter == nil, не имеет смысла регистрировать Sticker.
    displayFooter.map { _ in
      tableView.register(Sticker.self)
    }
  }
  
  private func setupAutomaticDimensioning() {
    if displayFooter == nil {
      tableView.sectionFooterHeight = 0
      tableView.estimatedSectionFooterHeight = 0
    } else {
      tableView.sectionFooterHeight = UITableView.automaticDimension
      tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
    }
  }

  /// Возвращает стикер, отображающий указанный футер.
  /// Если в тэйбл-вью не настроено отображение футеров, возвращает `nil`.
  /// - Parameters:
  ///   - footer: Футер, который надо отобразить.
  ///   - relativePosition: Относительная позиция секции в тэйбл-вью.
  open func sticker(footer: Footer,
                    relativePosition: SectionRelativePosition) -> Sticker? {
    displayFooter.flatMap { displayFooter in
      let sticker = tableView.dequeue(Sticker.self)

      displayFooter(footer, sticker, relativePosition)

      return sticker
    }
  }
  
  func events(sticker: Sticker) -> Observable<Event>? {
    stickerEvents?(sticker)
  }
  
  open func heightForFooter(_ footer: Footer?,
                            relativePosition: SectionRelativePosition) -> CGFloat {
    switch footer {
    case nil:
      return 0
    case let someFooter?:
      displayFooter?(someFooter, sampleSticker, relativePosition)

      return sampleSticker.heightFor(
        value: someFooter,
        width: tableView.frame.width
      )
    }
  }
}
