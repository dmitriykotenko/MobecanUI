//  Copyright © 2020 Mobecan. All rights reserved.


import UIKit


open class SausageView: UIView {
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init() {
    super.init(frame: .zero)
    
    clipsToBounds = true
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize { size }

  override open var frame: CGRect {
    didSet { layer.cornerRadius = min(bounds.width, bounds.height) / 2 }
  }
  
  override open var bounds: CGRect {
    didSet { layer.cornerRadius = min(bounds.width, bounds.height) / 2 }
  }
}
