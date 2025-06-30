// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  @MemberwiseInit
  public struct Rgb: Equatable, Hashable, Codable, Lensable {

    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat = 1

    public var uiColor: UIColor {
      .init(
        red: red,
        green: green,
        blue: blue,
        alpha: alpha
      )
    }

    public var displayP3: DisplayP3 {
      uiColor.cgColor.convertedToDisplayP3.asCodableDisplayP3
    }
  }

  public static func rgb(red: CGFloat,
                         green: CGFloat,
                         blue: CGFloat,
                         alpha: CGFloat = 1) -> Self {
    .rgb(.init(
      red: red,
      green: green,
      blue: blue,
      alpha: alpha
    ))
  }
}


extension CGColor {

  var asCodableDisplayP3: CodableColor.DisplayP3 {
    .init(
      red: components?[safe: 0] ?? 0,
      green: components?[safe: 1] ?? 0,
      blue: components?[safe: 2] ?? 0,
      alpha: components?[safe: 3] ?? alpha
    )
  }

  var convertedToDisplayP3: CGColor {
    converted(
      to: .displayP3space,
      intent: .defaultIntent,
      options: nil
    )!
  }
}
