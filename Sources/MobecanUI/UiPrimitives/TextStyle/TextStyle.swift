// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


@MemberwiseInit
public struct TextStyle: Lensable {
  
  public var fontStyle: FontStyle?
  public var alignment: NSTextAlignment?
  public var color: UIColor?
  
  public static var left = TextStyle(alignment: .left)
  public static var centered = TextStyle(alignment: .center)
  public static var right = TextStyle(alignment: .right)

  public static var monospacedDigits = TextStyle(
    fontStyle: .init(features: [FontStyle.monospacedDigits])
  )

  public func with(fontStyle: FontStyle? = nil,
                   alignment: NSTextAlignment? = nil,
                   color: UIColor? = nil) -> TextStyle {
    with(
      TextStyle(
        fontStyle: fontStyle,
        alignment: alignment,
        color: color
      )
    )
  }
  
  public func with(_ textStyle: TextStyle) -> TextStyle {
    TextStyle(
      fontStyle: textStyle.fontStyle ?? fontStyle,
      alignment: textStyle.alignment ?? alignment,
      color: textStyle.color ?? color
    )
  }
}
