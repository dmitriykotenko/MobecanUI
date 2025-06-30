// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


/// Tuple-based representation of a color
/// (e. g. (r, g, b), (l, a, b), (l, c, h) etc).
///
/// Used for conversions between different color spaces.
typealias ColorComponents = (Double, Double, Double)


/// A 3×3 matrix used for conversions between different color spaces.
struct ColorMatrix {

  var x: ColorComponents
	var y: ColorComponents
	var z: ColorComponents

  static func * (this: ColorMatrix,
                 vector: ColorComponents) -> ColorComponents {
    this.multiplyTo(vector)
  }

  private func multiplyTo(_ components: ColorComponents) -> ColorComponents {
		(
			components.0 * x.0 + components.1 * x.1 + components.2 * x.2,
			components.0 * y.0 + components.1 * y.1 + components.2 * y.2,
			components.0 * z.0 + components.1 * z.1 + components.2 * z.2
		)
	}
}
