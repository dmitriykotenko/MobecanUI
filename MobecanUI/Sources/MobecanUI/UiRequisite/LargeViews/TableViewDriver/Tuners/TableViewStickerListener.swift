//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


class TableViewStickerListener<Header, Event> {

  @RxOutput var events: Observable<Event>

  private var listenedStickers: Set<UITableViewHeaderFooterView> = []
  
  private let disposeBag = DisposeBag()
  
  func listen(sticker: UITableViewHeaderFooterView,
              events: Observable<Event>) {
    // Avoid multiple subscriptions to same cell
    guard !listenedStickers.contains(sticker) else { return }
    
    listenedStickers.insert(sticker)
    
    events.neverEnding()
      .bind(to: _events)
      .disposed(by: disposeBag)
  }
}
