// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public class ColoredEditableFieldBackground: LayoutableView, EditableFieldBackgroundProtocol {

  public lazy var state: AnyObserver<State> = .onNext { [weak self, borderColors, borderWidth] in
    self?.border(
      .init(color: borderColors[$0] ?? .clear, width: borderWidth)
    )
  }

  private let borderWidth: CGFloat
  private let borderColors: [State: UIColor]

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(cornerRadius: CGFloat,
              backgroundColor: UIColor?,
              borderWidth: CGFloat,
              borderColors: [State: UIColor]) {
    self.borderWidth = borderWidth
    self.borderColors = borderColors

    super.init()

    self
      .backgroundColor(backgroundColor ?? .clear)
      .cornerRadius(cornerRadius)
  }
}
