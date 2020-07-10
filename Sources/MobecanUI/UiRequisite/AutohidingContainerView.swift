//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


/// Automatically hides and shows itself when content view's visibility changes.
public class AutohidingContainerView: ClickThroughView {
  
  private var visibilityListener: NSKeyValueObservation?
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(_ subview: UIView,
              insets: UIEdgeInsets = .zero) {
    
    super.init(frame: .zero)
    
    putSubview(subview, insets: insets)
    
    visibilityListener = subview.observe(\.isHidden, options: .initial) { [weak self] view, _ in
      self?.isHidden = view.isHidden
    }
  }
}
