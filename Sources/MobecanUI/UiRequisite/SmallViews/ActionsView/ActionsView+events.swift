//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public extension ActionsView {
  
  func sideEvents(_ action: SideAction) -> Observable<Value> {
    viewEvents.compactMap {
      if case .sideAction(action, let value) = $0 { return value } else { return nil }
    }
  }
  
  var selectEvents: Observable<Value> {
    viewEvents.compactMap {
      if case .select(let value) = $0 { return value } else { return nil }
    }
  }
  
  var deselectEvents: Observable<Value> {
    viewEvents.compactMap {
      if case .deselect(let value) = $0 { return value } else { return nil }
    }
  }
}
