// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIColor {
  
  func mixed(with anotherColor: UIColor) -> UIColor {
    let thisRgb = RGB(self)
    let thatRgb = RGB(anotherColor)
    
    return UIColor(
      displayP3Red: (thisRgb.red + thatRgb.red) / 2,
      green: (thisRgb.green + thatRgb.green) / 2,
      blue: (thisRgb.blue + thatRgb.blue) / 2,
      alpha: (thisRgb.alpha + thatRgb.alpha) / 2
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


private struct RGB {

  var red: CGFloat = 0
  var green: CGFloat = 0
  var blue: CGFloat = 0
  var alpha: CGFloat = 0
  
  init(_ color: UIColor) {
    _ = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
  }
}
