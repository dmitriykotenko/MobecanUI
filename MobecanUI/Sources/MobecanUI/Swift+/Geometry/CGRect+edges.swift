//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension CGRect {
  
  var center: CGPoint {
    return CGPoint(x: midX, y: midY)
  }
  
  var topSideCenter: CGPoint {
    return CGPoint(x: midX, y: minY)
  }
  
  var bottomSideCenter: CGPoint {
    return CGPoint(x: midX, y: maxY)
  }
  
  var leftSideCenter: CGPoint {
    return CGPoint(x: minX, y: midY)
  }
  
  var rightSideCenter: CGPoint {
    return CGPoint(x: maxX, y: midY)
  }
}
