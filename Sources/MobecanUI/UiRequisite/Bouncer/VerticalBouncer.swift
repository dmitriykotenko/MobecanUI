// Copyright © 2020 Mobecan. All rights reserved.


import RxGesture
import SwiftDateTime
import UIKit


public class VerticalBouncer: Bouncer {

  public convenience init(panContainer: UIView,
                          pan: PanControlEvent? = nil,
                          animationDuration: Duration,
                          attractors: [CGFloat] = [-20, 150]) {
    self.init(
      axis: .vertical,
      panContainer: panContainer,
      pan: pan,
      animationDuration: animationDuration,
      attractors: attractors
    )
  }
}
