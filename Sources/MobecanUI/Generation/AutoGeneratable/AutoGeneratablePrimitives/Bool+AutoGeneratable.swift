// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension Bool: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .pure { Bool.random() } }
}
