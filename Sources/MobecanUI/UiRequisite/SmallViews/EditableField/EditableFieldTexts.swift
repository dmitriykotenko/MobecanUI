// Copyright © 2020 Mobecan. All rights reserved.


public struct EditableFieldTexts {
  
  public let title: String?
  public let placeholder: String?
  public let hint: String?
  
  public init(title: String? = nil,
              placeholder: String? = nil,
              hint: String? = nil) {
    self.title = title
    self.placeholder = placeholder
    self.hint = hint
  }
  
  public static var empty: EditableFieldTexts {
    EditableFieldTexts(title: nil, placeholder: nil, hint: nil)
  }
  
  public static var sample: EditableFieldTexts {
    EditableFieldTexts(title: "Field", placeholder: "Placeholder", hint: "Hint")
  }
}
