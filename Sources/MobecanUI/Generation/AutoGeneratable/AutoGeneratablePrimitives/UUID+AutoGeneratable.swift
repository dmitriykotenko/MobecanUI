// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension UUID: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> {
    .pure { .init() }
  }
}
