// Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import UIKit


class TableViewStickerTuner<Header, Sticker: UITableViewHeaderFooterView & HeightAwareView, Event>
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
    // Register Sticker only if the displayHeader is not nil.
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

  // Returns sticker displaying given header.
  // If there should be no sections header, returns nil.
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
  
  open func heightForHeader(_ header: Header?) -> CGFloat {
    header
      .flatMap { sampleSticker.heightFor(value: $0, width: tableView.frame.width) }
      ?? 0
  }
}
