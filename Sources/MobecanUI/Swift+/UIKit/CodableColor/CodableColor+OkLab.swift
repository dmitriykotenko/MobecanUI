// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  @available(iOS, deprecated: 1, message: "Is buggy.")
  public static func okLab(lightness: CGFloat,
                           a: CGFloat,
                           b: CGFloat,
                           alpha: CGFloat = 1) -> Self {
    .okLab(.init(
      lightness: lightness,
      a: a,
      b: b,
      alpha: alpha
    ))
  }

  @available(iOS, deprecated: 1, message: "Is buggy.")
  @MemberwiseInit
  public struct OkLab: Equatable, Hashable, Codable, Lensable {

    /// A lightness value in the range 0 to 1, with 0 being the darkest, and 1 being the brightest.
    public var lightness: CGFloat

    /// A number between -0.4 and 0.4,
    /// which specifies the distance along the a axis in the Oklab colorspace,
    /// that is how green/red the color is.
    public var a: CGFloat

    /// A number between -0.4 and 0.4,
    /// which specifies the distance along the b axis in the Oklab colorspace,
    /// that is how blue/yellow the color is.
    public var b: CGFloat

    /// An optional degree of opacity, in the range 0 to 1,
    /// with 0 being fully transparent, and 1 being fully opaque.
    /// The default is 1.
    public var alpha: CGFloat = 1

    @available(iOS, deprecated: 1, message: "Is buggy.")
    public var xyz: XYZ {
      let okLabToLms = ColorMatrix(
        x: (0.99999999845051981432,  0.39633779217376785678,   0.21580375806075880339),
        y: (1.0000000088817607767,  -0.1055613423236563494,   -0.063854174771705903402),
        z: (1.0000000546724109177,  -0.089484182094965759684, -1.2914855378640917399)
      )

      let (l, m, s) = okLabToLms * (lightness, a, b)

      let lmsToXyz = ColorMatrix(
        x: ( 1.2268798733741557,  -0.5578149965554813,  0.28139105017721583),
        y: (-0.04057576262431372,  1.1122868293970594, -0.07171106666151701),
        z: (-0.07637294974672142, -0.4214933239627914,  1.5869240244272418)
      )

      let (x, y, z) = lmsToXyz * (
        pow(l, 3),
        pow(m, 3),
        pow(s, 3)
      )

      return XYZ(x: x, y: y, z: z, alpha: alpha)
    }

    public var displayP3: DisplayP3 { xyz.displayP3 }

    @available(iOS, deprecated: 1, message: "Is buggy.")
    public var okLch: OkLch {
      .init(
        lightness: lightness,
        chroma: sqrt(a * a + b * b),
        hue: ((atan2(b, a) * 180 / .pi) + 360.0).truncatingRemainder(dividingBy: 360),
        alpha: alpha
      )
    }
  }
}
