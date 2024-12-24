// Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import UIKit


class TableViewTopStickerTuner<Header, Sticker: UITableViewHeaderFooterView & HeightAwareView, Event>
where Sticker.Value == Header {
  
  private var tableView: UITableView
  private var displayHeader: ((Header, Sticker, SectionRelativePosition) -> Void)?
  private var stickerEvents: ((Sticker) -> Observable<Event>)?
  
  private lazy var sampleSticker = Sticker(reuseIdentifier: "")

  init(tableView: UITableView,
       displayHeader: ((Header, Sticker, SectionRelativePosition) -> Void)?,
       stickerEvents: ((Sticker) -> Observable<Event>)?) {
    
    self.tableView = tableView
    self.displayHeader = displayHeader
    self.stickerEvents = stickerEvents

    registerSticker()
    setupAutomaticDimensioning()
  }
  
  private func registerSticker() {
    // Если displayHeader == nil, не имеет смысла регистрировать Sticker.
    displayHeader.map { _ in
      tableView.register(Sticker.self)
    }
  }
  
  private func setupAutomaticDimensioning() {
    if displayHeader == nil {
      tableView.sectionHeaderHeight = 0
      tableView.estimatedSectionHeaderHeight = 0
    } else {
      tableView.sectionHeaderHeight = UITableView.automaticDimension
      tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
    }
  }

  /// Возвращает стикер, отображающий указанный заголовок.
  /// Если в тэйбл-вью не настроено отображение заголовков секций, возвращает `nil`.
  /// - Parameters:
  ///   - header: Заголовок, который надо отобразить.
  ///   - relativePosition: Относительная позиция секции в тэйбл-вью.
  open func sticker(header: Header,
                    relativePosition: SectionRelativePosition) -> Sticker? {
    displayHeader.flatMap { displayHeader in
      let sticker = tableView.dequeue(Sticker.self)

      displayHeader(header, sticker, relativePosition)

      return sticker
    }
  }
  
  func events(sticker: Sticker) -> Observable<Event>? {
    stickerEvents?(sticker)
  }
  
  open func heightForHeader(_ header: Header?,
                            relativePosition: SectionRelativePosition) -> CGFloat {
    switch header {
    case nil:
      return 0
    case let someHeader?:
      displayHeader?(someHeader, sampleSticker, relativePosition)

      return sampleSticker.heightFor(
        value: someHeader,
        width: tableView.frame.width
      )
    }
  }
}
