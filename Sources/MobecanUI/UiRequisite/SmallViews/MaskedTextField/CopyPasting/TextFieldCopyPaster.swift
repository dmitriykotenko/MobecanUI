import UIKit


/// Custom implementations of Cut and Paste commands for ``MaskedTextField``.
class TextFieldCopyPaster {
  
  private weak var textField: MaskedTextField?
  private weak var innerDelegate: UITextFieldDelegate?
  private weak var outerDelegate: UITextFieldDelegate?
  
  private let pasteboard = UIPasteboard.general
  
  init(textField: MaskedTextField,
       innerDelegate: UITextFieldDelegate,
       outerDelegate: UITextFieldDelegate) {
    self.textField = textField
    self.innerDelegate = innerDelegate
    self.outerDelegate = outerDelegate
  }
  
  func cut() {
    guard
      let outerDelegate = outerDelegate,
      let innerDelegate = innerDelegate,
      let textField = textField,
      let selectedText = textField.selectedText,
      let selectedUtf16range = textField.selectedUtf16range,
      let selectedSignificantUtf16range = textField.selectedSignificantUtf16range
      else { return }
    
    let shouldCut = outerDelegate.textField?(
      textField,
      shouldChangeCharactersIn: selectedSignificantUtf16range,
      replacementString: ""
    ) ?? true
    
    guard shouldCut else { return }
    
    // 1. Copy selected text to clipboard.
    pasteboard.string = selectedText
    
    // 2. Remove selected text from the screen.
    _ = innerDelegate.textField?(
      textField,
      shouldChangeCharactersIn: selectedUtf16range,
      replacementString: ""
    )
  }
  
  func paste() {
    guard
      let innerDelegate = innerDelegate,
      let textField = textField,
      let selectedUtf16range = textField.selectedUtf16range
      else { return }
    
    guard
      pasteboard.hasStrings,
      // Joining with spaces is default UITextField's behavior when pasting multiple strings at once.
      let pastedText = pasteboard.strings.map({ $0.joined(separator: " ") })
      else { return }
    
    _ = innerDelegate.textField?(
      textField,
      shouldChangeCharactersIn: selectedUtf16range,
      replacementString: pastedText
    )
  }
  
  private func significantRange(from range: NSRange) -> NSRange {
    textField?.decoratedText?.significantRange(from: range) ?? range
  }
}


private extension MaskedTextField {
  
  var selectedText: String? {
    guard
      let decoratedText = decoratedText,
      let selectedUtf16range = selectedUtf16range
      else { return nil }
    
    let selectedSubstring = NSString(string: decoratedText.content)
      .substring(with: selectedUtf16range)
    
    return selectedSubstring
  }

  var selectedRange: NSRange? {
    guard let selectedUtf16range = selectedUtf16range else { return nil }
    
    return decoratedText?.rangeFromUtf16Range(selectedUtf16range)
  }
  
  var selectedSignificantUtf16range: NSRange? {
    guard
      let selectedRange = selectedRange,
      let significantRange = decoratedText?.significantRange(from: selectedRange)
      else { return nil }
    
    return decoratedText?.significantUtf16range(from: significantRange)
  }
}
