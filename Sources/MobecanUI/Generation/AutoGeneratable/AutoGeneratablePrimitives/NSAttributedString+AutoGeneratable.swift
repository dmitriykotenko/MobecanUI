// Copyright © 2024 Mobecan. All rights reserved.

import Foundation
import RxSwift


extension NSAttributedString: AutoGeneratable {

  public static var defaultGenerator: MobecanGenerator<NSAttributedString> {
    .rxFunctional {
      String.defaultGenerator.generate(factory: $0).mapSuccess {
        .init(string: $0)
      }
    }
  }
}
