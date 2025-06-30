// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  @MemberwiseInit
  public struct Grayscale: Equatable, Hashable, Codable, Lensable {

    public var white: CGFloat
    public var alpha: CGFloat = 1

    public var displayP3: DisplayP3 {
      .init(
        red: white,
        green: white,
        blue: white,
        alpha: alpha
      )
    }
  }

  public static func grayscale(white: CGFloat,
                               alpha: CGFloat = 1) -> Self {
    .grayscale(.init(white: white, alpha: alpha))
  }
}
