// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


/// Аналог ``UIColor``, поддерживающий протокол ``Codable`` и дополнительные цветовые пространства.
@available(iOS 13.0, *)
@MemberwiseInit
public struct CodableDynamicColor: Equatable, Hashable, Codable {

  public var light: CodableColor
  public var dark: CodableColor?

  public var uiColor: UIColor {
    .init {
      if $0.userInterfaceStyle == .dark {
        (dark ?? light).uiColor
      } else {
        light.uiColor
      }
    }
  }
}


extension CodableColor {

  @available(iOS 13.0, *)
  public var asDynamicColor: CodableDynamicColor {
    .init(light: self)
  }
}
