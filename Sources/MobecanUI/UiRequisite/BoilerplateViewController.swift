// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


// Displays given view as root view and do nothing else.
open class BoilerplateViewController: UIViewController {
  
  private let contentView: UIView
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(view contentView: UIView) {
    self.contentView = contentView
    
    super.init(nibName: nil, bundle: nil)    
  }
    
  override open func loadView() {
    view = contentView
      // FIXME: temporary hack to completely avoid autolayout constraints creation
      .translatesAutoresizingMaskIntoConstraints(true)
  }
}
