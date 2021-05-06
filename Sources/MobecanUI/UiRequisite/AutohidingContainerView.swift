//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


/// Automatically hides and shows itself when content view's visibility changes.
public class AutohidingContainerView: ClickThroughView {
  
  private var visibilityListener: NSKeyValueObservation?
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(_ subview: UIView,
              layout: (UIView) -> (UIView, UIEdgeInsets)) {

    super.init(frame: .zero)

    let (mainSubview, insets) = layout(subview)

    putSubview(mainSubview, insets: insets)

    visibilityListener = subview.observe(\.isHidden, options: .initial) { [weak self] view, _ in
      self?.isHidden = view.isHidden
    }
  }

  public convenience init(_ subview: UIView,
                          insets: UIEdgeInsets = .zero) {
    self.init(subview) { ($0, insets) }
  }
}
