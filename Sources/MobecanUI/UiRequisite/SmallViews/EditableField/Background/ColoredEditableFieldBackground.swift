// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


open class ColoredEditableFieldBackground: LayoutableView, EditableFieldBackgroundProtocol {

  open lazy var state: AnyObserver<State> = .onNext { [weak self, tintColors] in
    self?.updateTintColor(tintColors[$0] ?? .clear)
  }

  private let tintColors: [State: UIColor]
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(tintColors: [State: UIColor]) {
    self.tintColors = tintColors

    super.init()
  }

  open func updateTintColor(_ tintColor: UIColor) {
    border(
      .init(color: tintColor, width: 1)
    )
  }
}
