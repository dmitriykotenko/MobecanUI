//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


extension ActionsView {
  
  public var deleteEvents: Observable<Value> {
    viewEvents.compactMap {
      if case .delete(let value) = $0 { return value } else { return nil }
    }
  }
  
  public var selectEvents: Observable<Value> {
    viewEvents.compactMap {
      if case .select(let value) = $0 { return value } else { return nil }
    }
  }
  
  public var deselectEvents: Observable<Value> {
    viewEvents.compactMap {
      if case .deselect(let value) = $0 { return value } else { return nil }
    }
  }
}
