import Foundation


extension String {
  
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    guard
      let start16 = utf16.index(
        utf16.startIndex,
        offsetBy: nsRange.location,
        limitedBy: utf16.endIndex
      ),
      let end16 = utf16.index(
        utf16.startIndex,
        offsetBy: nsRange.location + nsRange.length,
        limitedBy: utf16.endIndex
      ),
      let start = start16.samePosition(in: self),
      let end = end16.samePosition(in: self)
      else { return nil }
    
    return start ..< end
  }
}
