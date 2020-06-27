//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension EditableField where RawValue == String? {
  
  convenience init(textView: UITextView,
                   backgroundView: EditableFieldBackground,
                   initSubviews: @escaping (UIView, EditableFieldBackground) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: @escaping (String?) -> Result<ValidatedValue, ValidationError>) {
    self.init(
      subviews: initSubviews(textView, backgroundView),
      layout: layout,
      rawValueGetter: textView.rx.text.asObservable(),
      rawValueSetter: textView.rx.text.asObserver(),
      validator: validator
    )
  }
}


public extension EditableField where RawValue == String?, ValidatedValue == String? {
  
  convenience init(textView: UITextView,
                   backgroundView: EditableFieldBackground,
                   initSubviews: @escaping (UIView, EditableFieldBackground) -> EditableFieldSubviews,
                   layout: EditableFieldLayout) {
    self.init(
      subviews: initSubviews(textView, backgroundView),
      layout: layout,
      rawValueGetter: textView.rx.text.asObservable(),
      rawValueSetter: textView.rx.text.asObserver(),
      validator: { .success($0) }
    )
  }
}
