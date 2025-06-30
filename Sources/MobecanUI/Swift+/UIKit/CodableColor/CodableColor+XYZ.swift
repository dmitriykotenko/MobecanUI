// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  /// An XYZ value in the XYZ color space
  @MemberwiseInit
  public struct XYZ: Equatable, Hashable, Codable, Lensable {

    public var x: CGFloat
    public var y: CGFloat
    public var z: CGFloat
    public var alpha: CGFloat = 1

    var asVector: ColorComponents { (x, y, z) }

    public var displayP3: DisplayP3 {
      let xyzToLinearP3 = ColorMatrix(
        x: (2.4934969, -0.9313836, -0.4027108),
        y: (-0.8294890, 1.7626641, 0.0236247),
        z: (0.0358458, -0.0761724, 0.9568845)
      )

      let (r, g, b) = xyzToLinearP3 * (x, y, z)

      return DisplayP3(
        red: r,
        green: g,
        blue: b,
        alpha: alpha
      )
      .gammaCorrected
    }

    @available(iOS, deprecated: 1, message: "Is buggy.")
    public var okLab: OkLab {
      let xyzToLms = ColorMatrix(
        x: (0.8189330101, 0.3618667424, -0.1288597137),
        y: (0.0329845436, 0.9293118715, 0.0361456387),
        z: (0.0482003018, 0.2643662691, 0.6338517070)
      )

      let lmsToOkLab = ColorMatrix(
        x: (0.2104542553, 0.7936177850, -0.0040720468),
        y: (1.9779984951, -2.4285922050, 0.4505937099),
        z: (0.0259040371, 0.7827717662, -0.8086757660)
      )

      let (l, m, s) = xyzToLms * asVector

      let oneThird: CGFloat = 1.0 / 3.0

      let lms_cubeRoot = (
        pow(l, oneThird),
        pow(m, oneThird),
        pow(s, oneThird)
      )

      let (lightness, a, b) = lmsToOkLab * lms_cubeRoot

      return .init(
        lightness: lightness,
        a: a,
        b: b,
        alpha: alpha
      )
    }
  }
}
