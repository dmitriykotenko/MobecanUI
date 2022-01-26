// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension EditableField where RawValue == ValidatedValue {
  
  convenience init(subviews: EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   rawValueGetter: Observable<RawValue>,
                   rawValueSetter: AnyObserver<RawValue>,
                   selectNextField: Observable<Void> = .never()) {
    self.init(
      subviews: subviews,
      layout: layout,
      rawValueGetter: rawValueGetter,
      rawValueSetter: rawValueSetter,
      validator: { .success($0) },
      selectNextField: selectNextField
    )
  }
}
