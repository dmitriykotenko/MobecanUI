//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct TextStyle {
  
  public let fontStyle: FontStyle?
  public let alignment: NSTextAlignment?
  public let color: UIColor?
  
  public static var left = TextStyle(alignment: .left)
  public static var centered = TextStyle(alignment: .center)
  public static var right = TextStyle(alignment: .right)

  public static var monospacedDigits = TextStyle(
    fontStyle: .init(features: [FontStyle.monospacedDigits])
  )
  
  public init(fontStyle: FontStyle? = nil,
              alignment: NSTextAlignment? = nil,
              color: UIColor? = nil) {
    self.fontStyle = fontStyle
    self.alignment = alignment
    self.color = color
  }
  
  public func with(fontStyle: FontStyle? = nil,
                   alignment: NSTextAlignment? = nil,
                   color: UIColor? = nil) -> TextStyle {
    return with(
      TextStyle(
        fontStyle: fontStyle,
        alignment: alignment,
        color: color
      )
    )
  }
  
  public func with(_ textStyle: TextStyle) -> TextStyle {
    return TextStyle(
      fontStyle: textStyle.fontStyle ?? fontStyle,
      alignment: textStyle.alignment ?? alignment,
      color: textStyle.color ?? color
    )
  }
}
