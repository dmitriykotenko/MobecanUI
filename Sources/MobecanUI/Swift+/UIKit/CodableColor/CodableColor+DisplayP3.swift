// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  public static func displayP3(red: CGFloat,
                               green: CGFloat,
                               blue: CGFloat,
                               alpha: CGFloat = 1) -> Self {
    .displayP3(.init(
      red: red,
      green: green,
      blue: blue,
      alpha: alpha
    ))
  }

  @MemberwiseInit
  public struct DisplayP3: Equatable, Hashable, Codable, Lensable {

    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat = 1

    public var uiColor: UIColor {
      .init(
        displayP3Red: red,
        green: green,
        blue: blue,
        alpha: alpha
      )
    }

    var gammaCorrected: Self {
      .init(
        red: gammaCorrected(red),
        green: gammaCorrected(green),
        blue: gammaCorrected(blue),
        alpha: alpha
      )
    }

    var linearized: Self {
      .init(
        red: linearized(red),
        green: linearized(green),
        blue: linearized(blue),
        alpha: alpha
      )
    }

    func gammaCorrected(_ c: Double) -> Double {
      let sign = (c.sign == .plus) ? 1.0 : -1.0

      return if abs(c) > 0.0031308 {
        sign * (1.055 * pow(abs(c), 1 / 2.4) - 0.055)
      } else {
        12.92 * c
      }
    }

    func linearized(_ c: Double) -> Double {
      if c <= 0.04045 {
        c / 12.92
      } else {
        pow((c + 0.055) / 1.055, 2.4)
      }
    }

    public var xyz: XYZ {
      let linear = linearized

      let linearP3ToXyz = ColorMatrix(
        x: (0.4865709, 0.2656677, 0.1982173),
        y: (0.2289746, 0.6917385, 0.0792869),
        z: (0.0000000, 0.0451134, 1.0439444)
      )

      let (x, y, z) = linearP3ToXyz * (linear.red, linear.green, linear.blue)

      return XYZ(
        x: x,
        y: y,
        z: z,
        alpha: alpha
      )
    }
  }
}
