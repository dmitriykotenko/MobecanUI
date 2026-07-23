// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit


/// Автоматически скрывает или показывает себя, когда меняется видимость контент-вьюшки.
public class AutohidingContainerView: LayoutableView {

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(_ subview: UIView,
              layout: (UIView) -> UIView = { $0 },
              insets: UIEdgeInsets = .zero) {

    super.init()

    self.isClickThroughEnabled = true

    self.layout = BoilerplateLayout(layout(subview)).withInsets(insets)

    withVisibility(derivedFrom: subview)
  }
}
