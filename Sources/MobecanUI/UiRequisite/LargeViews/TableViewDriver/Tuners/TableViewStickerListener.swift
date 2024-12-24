// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


class TableViewStickerListener<Header, Event> {

  @RxOutput var events: Observable<Event>

  private var listenedStickers: Set<UITableViewHeaderFooterView> = []
  
  private let disposeBag = DisposeBag()
  
  func listen(sticker: UITableViewHeaderFooterView,
              events: Observable<Event>) {
    // На каждый стикер подписываемся только один раз.
    guard !listenedStickers.contains(sticker) else { return }
    
    listenedStickers.insert(sticker)

    disposeBag {
      events ==> _events
    }
  }
}
