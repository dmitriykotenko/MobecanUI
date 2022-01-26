// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public extension ActionsView {
  
  var deleteEvents: Observable<Value> {
    viewEvents.compactMap {
      if case .delete(let value) = $0 { return value } else { return nil }
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
