import Foundation


struct TextReplacementOperation {
  let rangeToBeReplaced: NSRange
  let replacementString: String
  
  var isEmpty: Bool {
    rangeToBeReplaced.length == 0 && replacementString.isEmpty
  }
}
