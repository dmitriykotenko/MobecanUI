//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension Reactive where Base: UILabel {

  var textColor: Binder<UIColor?> {
    Binder(base) { label, textColor in
      label.textColor = textColor
    }
  }
}
