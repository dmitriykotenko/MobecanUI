//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


// Displays given view as root view and do nothing else.
public class BoilerplateViewController: UIViewController {
  
  private let contentView: UIView
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(view contentView: UIView) {
    self.contentView = contentView
    
    super.init(nibName: nil, bundle: nil)    
  }
    
  override public func loadView() {
    view = contentView
  }
}
