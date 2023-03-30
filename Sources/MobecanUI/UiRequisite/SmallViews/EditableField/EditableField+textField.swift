// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public extension EditableField where RawValue == String?, ValidatedValue == String? {
  
  convenience init(textField: UITextField,
                   backgroundView: EditableFieldBackgroundProtocol,
                   initSubviews: @escaping (UIView, EditableFieldBackgroundProtocol) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: ((RawValue) -> SoftResult<ValidatedValue, ValidationError>)? = nil) {
    
    let sampleValidator = { (rawValue: RawValue) -> SoftResult<ValidatedValue, ValidationError> in
      print("Sample validator for text field.")
      return .success(rawValue)
    }
    
    self.init(
      subviews: initSubviews(textField, backgroundView),
      layout: layout,
      rawValueGetter: textField.rx.text.asObservable(),
      rawValueSetter: textField.rx.text.asObserver(),
      validator: validator ?? sampleValidator
    )
  }
}


public extension EditableField where RawValue == String? {
  
  convenience init(textField: UITextField,
                   backgroundView: EditableFieldBackgroundProtocol,
                   initSubviews: @escaping (UIView, EditableFieldBackgroundProtocol) -> EditableFieldSubviews,
                   layout: EditableFieldLayout,
                   validator: @escaping (RawValue) -> SoftResult<ValidatedValue, ValidationError>) {
    
    self.init(
      subviews: initSubviews(textField, backgroundView),
      layout: layout,
      rawValueGetter: textField.rx.text.asObservable(),
      rawValueSetter: textField.rx.text.asObserver(),
      validator: validator
    )
  }
}
