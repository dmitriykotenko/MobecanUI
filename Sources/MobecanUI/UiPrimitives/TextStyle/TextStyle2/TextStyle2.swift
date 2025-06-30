// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


/// Улучшенная версия ``TextStyle``, поддерживающая протоколы ``Equatable``, ``Hashable`` и ``Codable``.
@MemberwiseInit
public struct TextStyle2: Equatable, Hashable, Codable, Lensable {

  public var fontStyle: FontStyle2?
  public var alignment: TextAlignment?
  public var color: CodableColor?

  public static var left = TextStyle2(alignment: .left)
  public static var centered = TextStyle2(alignment: .center)
  public static var right = TextStyle2(alignment: .right)

  public static var monospacedDigits = TextStyle2(
    fontStyle: .init(features: [FontStyle.monospacedDigits])
  )

  public var textStyleV1: TextStyle {
    .init(
      fontStyle: fontStyle?.fontStyleV1,
      alignment: alignment?.nsTextAlignment,
      color: color?.uiColor
    )
  }

  public func with(fontStyle: FontStyle2? = nil,
                   alignment: TextAlignment? = nil,
                   color: CodableColor? = nil) -> TextStyle2 {
    with(
      TextStyle2(
        fontStyle: fontStyle,
        alignment: alignment,
        color: color
      )
    )
  }
  
  public func with(_ textStyle: TextStyle2) -> TextStyle2 {
    TextStyle2(
      fontStyle: textStyle.fontStyle ?? fontStyle,
      alignment: textStyle.alignment ?? alignment,
      color: textStyle.color ?? color
    )
  }
}
