// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


/// Аналог ``UIColor``, поддерживающий протокол ``Codable`` и дополнительные цветовые пространства.
public enum CodableColor: Equatable, Hashable, Codable {

  case grayscale(Grayscale)
  case rgb(Rgb)
  case displayP3(DisplayP3)

  @available(iOS, deprecated: 1, message: "Is buggy.")
  case lch(Lch)

  @available(iOS, deprecated: 1, message: "Is buggy.")
  case lab(Lab)

  @available(iOS, deprecated: 1, message: "Is buggy.")
  case okLch(OkLch)

  @available(iOS, deprecated: 1, message: "Is buggy.")
  case okLab(OkLab)

  public init(r: Int,
              g: Int,
              b: Int,
              alpha: CGFloat = 1) {
    self = .rgb(
      red: CGFloat(r) / 255.0,
      green: CGFloat(g) / 255.0,
      blue: CGFloat(b) / 255.0,
      alpha: alpha
    )
  }

  public var alpha: CGFloat {
    switch self {
    case .grayscale(let grayscale):
      grayscale.alpha
    case .rgb(let rgb):
      rgb.alpha
    case .displayP3(let displayP3):
      displayP3.alpha
    case .lch(let lch):
      lch.alpha
    case .lab(let lab):
      lab.alpha
    case .okLch(let okLch):
      okLch.alpha
    case .okLab(let okLab):
      okLab.alpha
    }
  }

  public var uiColor: UIColor { displayP3.uiColor }
  public var cgColor: CGColor { uiColor.cgColor }
  public var asDisplayP3color: Self { .displayP3(displayP3) }

  public var displayP3: DisplayP3 {
    switch self {
    case .grayscale(let grayscale):
      grayscale.displayP3
    case .rgb(let rgb):
      rgb.displayP3
    case .displayP3(let displayP3):
      displayP3
    case .lch(let lch):
      lch.displayP3
    case .lab(let lab):
      lab.displayP3
    case .okLch(let okLch):
      okLch.displayP3
    case .okLab(let okLab):
      okLab.displayP3
    }
  }

  @available(iOS, deprecated: 1, message: "Is buggy.")
  public var okLch: OkLch {
    switch self {
    case .okLch(let okLch):
      okLch
    default:
      displayP3.xyz.okLab.okLch
    }
  }

  func withAlphaMultiplied(by multiplier: CGFloat) -> Self {
    withAlphaComponent(multiplier * alpha)
  }

  public func withAlphaComponent(_ alpha: CGFloat) -> Self {
    switch self {
    case .grayscale(let grayscale):
      .grayscale(grayscale[\.alpha, alpha])
    case .rgb(let rgb):
      .rgb(rgb[\.alpha, alpha])
    case .displayP3(let displayP3):
      .displayP3(displayP3[\.alpha, alpha])
    case .lch(let lch):
      .lch(lch[\.alpha, alpha])
    case .lab(let lab):
      .lab(lab[\.alpha, alpha])
    case .okLch(let okLch):
      .okLch(okLch[\.alpha, alpha])
    case .okLab(let okLab):
      .okLab(okLab[\.alpha, alpha])
    }
  }

  @available(iOS, deprecated: 1, message: "Is buggy.")
  public func withBrightnessMultiplied(by multiplier: CGFloat) -> CodableColor {
    switch self {
    case .okLch(let okLch):
      .okLch(okLch[\.lightness, { $0 * multiplier }])
    case .okLab(let okLab):
      .okLab(okLab[\.lightness, { $0 * multiplier }])
    default:
      .displayP3(
        okLch[\.lightness, { $0 * multiplier }].displayP3
      )
    }
  }
}
