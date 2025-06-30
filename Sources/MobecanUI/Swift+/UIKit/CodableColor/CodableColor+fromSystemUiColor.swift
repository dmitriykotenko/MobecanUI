// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension CodableColor {

  public init(systemNonDynamicUiColor uiColor: UIColor) {
    self = .displayP3(uiColor.cgColor.convertedToDisplayP3.asCodableDisplayP3)
  }

  public static let clear = CodableColor(systemNonDynamicUiColor: .clear)

  public static let black = CodableColor(systemNonDynamicUiColor: .black)
  public static let white = CodableColor(systemNonDynamicUiColor: .white)
  public static let darkGray = CodableColor(systemNonDynamicUiColor: .darkGray)
  public static let lightGray = CodableColor(systemNonDynamicUiColor: .lightGray)

  public static let red = CodableColor(systemNonDynamicUiColor: .red)
  public static let green = CodableColor(systemNonDynamicUiColor: .green)
  public static let yellow = CodableColor(systemNonDynamicUiColor: .yellow)
  public static let blue = CodableColor(systemNonDynamicUiColor: .blue)

  public static let orange = CodableColor(systemNonDynamicUiColor: .orange)
  public static let purple = CodableColor(systemNonDynamicUiColor: .purple)
  public static let magenta = CodableColor(systemNonDynamicUiColor: .magenta)
  public static let cyan = CodableColor(systemNonDynamicUiColor: .cyan)
  public static let brown = CodableColor(systemNonDynamicUiColor: .brown)
}
