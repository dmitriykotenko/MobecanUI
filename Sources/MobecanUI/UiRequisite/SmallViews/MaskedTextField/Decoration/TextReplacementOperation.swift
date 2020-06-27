import Foundation


struct TextReplacementOperation {
  let rangeToBeReplaced: NSRange
  let replacementString: String
  
  var isEmpty: Bool {
    return rangeToBeReplaced.length == 0 && replacementString.isEmpty
  }
}
