//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit


/// Automatically hides and shows itself when content view's visibility changes.
public class AutohidingContainerView: LayoutableView {
  
  private var visibilityListener: NSKeyValueObservation?
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(_ subview: UIView,
              layout: (UIView) -> UIView = { $0 },
              insets: UIEdgeInsets = .zero) {

    super.init()

    self.isClickThroughEnabled = true

    self.layout = InsetLayout(
      insets: insets,
      sublayout: BoilerplateLayout(layout(subview))
    )

    visibilityListener = subview.observe(\.isHidden, options: .initial) { [weak self] view, _ in
      self?.isHidden = view.isHidden
    }
  }
}
