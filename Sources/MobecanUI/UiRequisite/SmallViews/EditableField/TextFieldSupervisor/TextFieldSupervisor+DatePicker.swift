// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


public extension TextFieldSupervisor where Value == DayMonthYear {

  convenience init(textField: UITextField,
                   dayMonthYearPicker: UIDatePicker,
                   accessoryView: UIControl,
                   dateFormatter: DayMonthYearFormatter,
                   autoappearingValue: DayMonthYear? = nil) {  
    self.init(
      textField: textField,
      datePicker: dayMonthYearPicker,
      accessoryView: accessoryView,
      value: { $0.rx.dayMonthYear },
      valueFormatter: { dateFormatter.dotBasedStringFromDayMonthYear($0) },
      autoappearingValue: autoappearingValue
    )
  }
}


public extension TextFieldSupervisor {
  
  convenience init(textField: UITextField,
                   datePicker: UIDatePicker,
                   accessoryView: UIControl,
                   value: @escaping (UIDatePicker) -> ControlProperty<Value>,
                   valueFormatter: @escaping (Value) -> String,
                   autoappearingValue: Value? = nil) {
      
    self.init(
      textField: textField,
      keyboard: datePicker,
      keyboardAccessoryView: accessoryView,
      formatter: valueFormatter,
      value: ControlProperty(
        // Skip first value of datePicker – to prevent autofilling of text field until user makes it first responder.
        values: value(datePicker).skip(1).asObservable(),
        valueSink: value(datePicker).asObserver()
      ),
      autoappearingValue: autoappearingValue
    )
    
      accessoryView.addTarget(self, action: #selector(closeKeyboard), for: .primaryActionTriggered)
  }
}
