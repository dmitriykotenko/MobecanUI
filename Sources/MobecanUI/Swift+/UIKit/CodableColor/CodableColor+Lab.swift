// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  @available(iOS, deprecated: 1, message: "Is buggy.")
  public static func lab(lightness: CGFloat,
                         a: CGFloat,
                         b: CGFloat,
                         alpha: CGFloat = 1) -> Self {
    .lab(.init(
      lightness: lightness,
      a: a,
      b: b,
      alpha: alpha
    ))
  }

  @available(iOS, deprecated: 1, message: "Is buggy.")
  @MemberwiseInit
  public struct Lab: Equatable, Hashable, Codable, Lensable {

    /// A lightness value in the range 0 to 100, with 0 being the darkest, and 100 being the brightest.
    public var lightness: CGFloat

    /// A number between -125 and 125,
    /// which specifies the distance along the a axis in the CIELab colorspace,
    /// that is how green/red the color is.
    public var a: CGFloat

    /// A number between -125 and 125,
    /// which specifies the distance along the b axis in the CIELab colorspace,
    /// that is how blue/yellow the color is
    public var b: CGFloat

    /// An optional degree of opacity, in the range 0 to 1,
    /// with 0 being fully transparent, and 1 being fully opaque.
    /// The default is 1.
    public var alpha: CGFloat = 1

    public var xyz: XYZ {
      let k: CGFloat = 24389.0 / 27.0
      let e: CGFloat = 216.0 / 24389.0

      let fy = (lightness + 16) / 116
      let fx = fy + (a / 500)
      let fz = fy - (b / 200)

      let x = pow(fx, 3) > e     ? pow(fx, 3) : (116 * fx - 16) / k
      let y = lightness  > k * e ? pow(fy, 3) : lightness / k
      let z = pow(fz, 3) > e     ? pow(fz, 3) : (116 * fz - 16) / k

      let d65WhitePoint = (
        x: 0.3127 / 0.3290,
        y: 1.00000,
        z: (1.0 - 0.3127 - 0.3290) / 0.3290
      )

      return XYZ(
        x: x * d65WhitePoint.x,
        y: y * d65WhitePoint.y,
        z: z * d65WhitePoint.z,
        alpha: alpha
      )
    }

    public var displayP3: DisplayP3 { xyz.displayP3 }
  }
}
