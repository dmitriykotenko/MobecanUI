//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension CGRect {
  
  var center: CGPoint { .init(x: midX, y: midY) }
  
  var topSideCenter: CGPoint { .init(x: midX, y: minY) }
  
  var bottomSideCenter: CGPoint { .init(x: midX, y: maxY) }
  
  var leftSideCenter: CGPoint { .init(x: minX, y: midY) }
  
  var rightSideCenter: CGPoint { .init(x: maxX, y: midY) }
}
