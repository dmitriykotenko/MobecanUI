// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIColor {

  struct RGBA {

    public var red: CGFloat = 0
    public var green: CGFloat = 0
    public var blue: CGFloat = 0
    public var alpha: CGFloat = 0

    public init(red: CGFloat = 0,
                green: CGFloat = 0,
                blue: CGFloat = 0,
                alpha: CGFloat = 0) {
      self.red = red
      self.green = green
      self.blue = blue
      self.alpha = alpha
    }

    init(_ color: UIColor) {
      _ = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
  }

  var rbga: RGBA { .init(self) }

  func mixed(with anotherColor: UIColor) -> UIColor {
    let thisRgba = RGB(self)
    let thatRgba = RGB(anotherColor)
    
    return UIColor(
      displayP3Red: (thisRgba.red + thatRgba.red) / 2,
      green: (thisRgba.green + thatRgba.green) / 2,
      blue: (thisRgba.blue + thatRgba.blue) / 2,
      alpha: (thisRgba.alpha + thatRgba.alpha) / 2
    )
  }
  
  func withAlphaMultiplied(by multiplier: CGFloat) -> UIColor {
    let alpha = HSB(self).alpha
    
    return withAlphaComponent(multiplier * alpha)
  }

  func withBrightnessMultiplied(by multiplier: CGFloat) -> UIColor {
    
    let hsb = HSB(self)
    
    return UIColor(
      hue: hsb.hue,
      saturation: hsb.saturation,
      brightness: hsb.brightness * multiplier,
      alpha: hsb.alpha
    )
  }
}


private struct HSB {

  var hue: CGFloat = 0
  var saturation: CGFloat = 0
  var brightness: CGFloat = 0
  var alpha: CGFloat = 0
  
  init(_ color: UIColor) {
    _ = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
  }
}
