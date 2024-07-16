// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension EquatableVoid: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<Self> { .fixed(.instance) }
}
