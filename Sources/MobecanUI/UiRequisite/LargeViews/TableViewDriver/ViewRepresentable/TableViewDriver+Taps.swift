// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension TableViewDriver where CellEvent == Tap<Element> {
  
  var cellTaps: Observable<Element> { cellEvents.map { $0.element } }
}


public extension TableViewDriver where StickerEvent == Tap<Header> {
  
  var stickerTaps: Observable<Header> { stickerEvents.map { $0.element } }
}
