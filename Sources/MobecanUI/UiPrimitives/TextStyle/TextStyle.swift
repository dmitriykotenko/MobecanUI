//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit
import CoreGraphics


public struct TextStyle {
  
  public var fontStyle: FontStyle?
  public var alignment: NSTextAlignment?
  public var color: UIColor?
  public var lineHeight: CGFloat?
  
  public static var left = TextStyle(alignment: .left)
  public static var right = TextStyle(alignment: .right)
  public static var centered = TextStyle(alignment: .center)
  public static var justified = TextStyle(alignment: .justified)

  public static func color(_ color: UIColor) -> TextStyle {
    .init(color: color)
  }

  public static func lineHeight(_ lineHeight: CGFloat) -> TextStyle {
    .init(lineHeight: lineHeight)
  }

  public static var monospacedDigits = TextStyle(
    fontStyle: .init(features: [FontStyle.monospacedDigits])
  )
  
  public init(fontStyle: FontStyle? = nil,
              alignment: NSTextAlignment? = nil,
              color: UIColor? = nil,
              lineHeight: CGFloat? = nil) {
    self.fontStyle = fontStyle
    self.alignment = alignment
    self.color = color
    self.lineHeight = lineHeight
  }
  
  public func with(fontStyle: FontStyle? = nil,
                   alignment: NSTextAlignment? = nil,
                   color: UIColor? = nil,
                   lineHeight: CGFloat? = nil) -> TextStyle {
    with(
      TextStyle(
        fontStyle: fontStyle,
        alignment: alignment,
        color: color,
        lineHeight: lineHeight
      )
    )
  }
  
  public func with(_ textStyle: TextStyle) -> TextStyle {
    TextStyle(
      fontStyle: textStyle.fontStyle ?? fontStyle,
      alignment: textStyle.alignment ?? alignment,
      color: textStyle.color ?? color,
      lineHeight: textStyle.lineHeight ?? lineHeight
    )
  }
}
