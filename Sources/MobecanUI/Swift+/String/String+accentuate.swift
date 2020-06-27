//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension String {
  
  func accentuate(text: String?,
                  backgroundColor: UIColor) -> NSAttributedString {
    guard let text = text else { return NSAttributedString(string: self) }
    
    do {
      let attributedString = NSMutableAttributedString(string: self)
      
      let regex = try NSRegularExpression(
        pattern: text
          .trimmingCharacters(in: .whitespacesAndNewlines)
          .folding(options: .diacriticInsensitive, locale: .current),
        options: .caseInsensitive
      )
      
      let range = NSRange(location: 0, length: self.utf16.count)
      
      let matches = regex.matches(
        in: self.folding(options: .diacriticInsensitive, locale: .current),
        options: .withTransparentBounds,
        range: range
      )
      
      matches.forEach {
        attributedString.addAttribute(
          .backgroundColor,
          value: backgroundColor,
          range: $0.range
        )
      }
      
      return attributedString
    } catch {
      print("Error creating regular expresion: \(error).")
      
      return NSAttributedString(string: self)
    }
  }
}
