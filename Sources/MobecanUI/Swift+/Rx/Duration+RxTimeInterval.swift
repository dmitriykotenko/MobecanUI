// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension Duration {
  
  var toRxTimeInterval: RxTimeInterval { toDispatchTimeInterval }
}
