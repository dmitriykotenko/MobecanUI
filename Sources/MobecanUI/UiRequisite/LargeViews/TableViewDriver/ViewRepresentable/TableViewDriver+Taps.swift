// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension TableViewDriver where CellEvent == Tap<Element> {
  
  var cellTaps: Observable<Element> { cellEvents.map { $0.element } }
}


public extension TableViewDriver where TopStickerEvent == Tap<Header> {

  var topStickerTaps: Observable<Header> { topStickerEvents.map { $0.element } }
}


public extension TableViewDriver where BottomStickerEvent == Tap<Footer> {

  var bottomStickerTaps: Observable<Footer> { bottomStickerEvents.map { $0.element } }
}
