//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct ButtonColorsState {
  
  public let state: UIControl.State
  public let colors: ButtonColors
  
  public init(state: UIControl.State,
              colors: ButtonColors) {
    self.state = state
    self.colors = colors
  }
  
  public static func normal(title: UIColor? = nil,
                            tint: UIColor? = nil,
                            background: UIColor? = nil,
                            shadow: UIColor? = nil) -> ButtonColorsState {
    return ButtonColorsState(
      state: .normal,
      colors: .init(
        title: title,
        tint: tint,
        background: background,
        shadow: shadow
      )
    )
  }
  
  public static func highlighted(title: UIColor? = nil,
                                 tint: UIColor? = nil,
                                 background: UIColor? = nil,
                                 shadow: UIColor? = nil) -> ButtonColorsState {
    return ButtonColorsState(
      state: .highlighted,
      colors: .init(
        title: title,
        tint: tint,
        background: background,
        shadow: shadow
      )
    )
  }
  
  public static func selected(title: UIColor? = nil,
                              tint: UIColor? = nil,
                              background: UIColor? = nil,
                              shadow: UIColor? = nil) -> ButtonColorsState {
    return ButtonColorsState(
      state: .selected,
      colors: .init(
        title: title,
        tint: tint,
        background: background,
        shadow: shadow
      )
    )
  }
  
  public static func disabled(title: UIColor? = nil,
                              tint: UIColor? = nil,
                              background: UIColor? = nil,
                              shadow: UIColor? = nil) -> ButtonColorsState {
    return ButtonColorsState(
      state: .disabled,
      colors: .init(
        title: title,
        tint: tint,
        background: background,
        shadow: shadow
      )
    )
  }
}
