// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public enum TextToBulletAlignment: String, Equatable, Hashable, Codable {
  
  case xHeight
  case capHeight

  public func height(font: UIFont) -> CGFloat {
    switch self {
    case .xHeight:
      return font.xHeight
    case .capHeight:
      return font.capHeight
    }
  }

  public func bulletCenterY(font: UIFont) -> CGFloat {
    switch self {
    case .xHeight:
      font.firstBaselineY - 0.5 * font.xHeight
    case .capHeight:
      font.firstBaselineY - 0.5 * font.capHeight
    }
  }
}


private extension UIFont {

  /// Расстояние от верхнего края UILabel, UITextField или UITextView до базовой линии первой строки текста
  /// (без учёта марджинов и паддингов).
  var firstBaselineY: CGFloat {
    // Если верить эпловской документации,
    // расстояние от верхнего края текста до базовой линии первой строки — это Font Ascent,
    // или (в терминологии UIFont) ascender:
    // https://developer.apple.com/library/archive/documentation/TextFonts/Conceptual/CocoaTextArchitecture/FontHandling/FontHandling.html#//apple_ref/doc/uid/TP40009459-CH5-SW5
    ascender
  }
}
