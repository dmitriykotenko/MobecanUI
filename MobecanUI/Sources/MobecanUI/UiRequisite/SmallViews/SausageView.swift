//  Copyright © 2020 Mobecan. All rights reserved.


import UIKit


public class SausageView: UIView {
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init() {
    super.init(frame: .zero)
    
    clipsToBounds = true
  }

  override public var frame: CGRect {
    didSet { layer.cornerRadius = min(bounds.width, bounds.height) / 2 }
  }
  
  override public var bounds: CGRect {
    didSet { layer.cornerRadius = min(bounds.width, bounds.height) / 2 }
  }
}
