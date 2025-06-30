// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


/// Аналог ``NSTextAlignment``, поддерживающий протоколы ``Equatable``, ``Hashable`` и ``Codable``.
public enum TextAlignment: Equatable, Hashable, Codable {

  case left
  case center
  case right
  case justified
  case natural

  public var nsTextAlignment: NSTextAlignment {
    switch self {
    case .left:
      .left
    case .center:
      .center
    case .right:
      .right
    case .justified:
      .justified
    case .natural:
      .natural
    }
  }

  public static func from(nsTextAlignment: NSTextAlignment) -> Self {
    switch nsTextAlignment {
    case .left:
      .left
    case .center:
      .center
    case .right:
      .right
    case .justified:
      .justified
    case .natural:
      .natural
    @unknown default:
      fatalError("Unsupported NSTextAlignment \(nsTextAlignment)")
    }
  }
}
