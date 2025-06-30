// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


/// Аналог ``UIFont.Weight``, поддерживающий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
@MemberwiseInit
public struct FontWeight: Equatable, Hashable, Codable, Lensable {

  public var rawValue: CGFloat

  public var uiFontWeight: UIFont.Weight {
    .init(rawValue: rawValue)
  }

  public static func from(uiFontWeight: UIFont.Weight) -> Self {
    .init(rawValue: uiFontWeight.rawValue)
  }
}
