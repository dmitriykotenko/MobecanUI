//  Copyright © 2020 Mobecan. All rights reserved.


import CoreGraphics
import RxCocoa
import RxSwift
import SnapKit


extension Constraint: ReactiveCompatible {}


public extension Reactive where Base: Constraint {
  
  var isActive: Binder<Bool> {
    return Binder(base) { constraint, isActive in
      constraint.isActive = isActive
    }
  }
  
  var offset: Binder<CGFloat> {
    return Binder(base) { constraint, offset in
      constraint.update(offset: offset)
    }
  }
  
  var inset: Binder<CGFloat> {
    return Binder(base) { constraint, inset in
      constraint.update(inset: inset)
    }
  }
}
