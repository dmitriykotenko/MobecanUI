// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public protocol LabelsGrid {
  
  associatedtype Texts: Equatable
  
  static var empty: Self { get }
  
  func view() -> UIView
  func display(texts: Texts)
    
  var firstBaselineLabel: UIView { get }
  var lastBaselineLabel: UIView { get }
}
