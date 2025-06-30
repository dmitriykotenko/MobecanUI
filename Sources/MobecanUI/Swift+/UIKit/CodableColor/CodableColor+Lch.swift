// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  @available(iOS, deprecated: 1, message: "Is buggy.")
  public static func lch(lightness: CGFloat,
                         chroma: CGFloat,
                         hue: CGFloat,
                         alpha: CGFloat = 1) -> Self {
    .lch(.init(
      lightness: lightness,
      chroma: chroma,
      hue: hue,
      alpha: alpha
    ))
  }

  @available(iOS, deprecated: 1, message: "Is buggy.")
  @MemberwiseInit
  public struct Lch: Equatable, Hashable, Codable, Lensable {

    /// A lightness value in the range 0 to 100, with 0 being the darkest, and 100 being the brightest.
    public var lightness: CGFloat

    /// A chroma value that is greater than 0,
    /// and with a theoretically unbounded maximum (practically, 230).
    /// Higher values represent a higher "amount" of colour.
    public var chroma: CGFloat

    /// A hue value in the range 0 to 360 that maps to the color wheel.
    public var hue: CGFloat

    /// An optional degree of opacity, in the range 0 to 1,
    /// with 0 being fully transparent, and 1 being fully opaque.
    /// The default is 1.
    public var alpha: CGFloat = 1

    public var lab: Lab {
      .init(
        lightness: lightness,
        a: cos(hue * .pi / 180) * chroma,
        b: sin(hue * .pi / 180) * chroma,
        alpha: alpha
      )
    }

    public var xyz: XYZ { lab.xyz }
    public var displayP3: DisplayP3 { lab.xyz.displayP3 }
  }
}
