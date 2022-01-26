// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import SnapKit
import UIKit


public class TranslationView: LayoutableView {

  @RxUiInput(.zero) public var translation: AnyObserver<CGPoint>
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(_ contentView: UIView) {
    super.init()

    self.layout = contentView.asLayout.withInsets(.zero)

    disposeBag {
      _translation ==> { [weak self] in
        self?.layout = contentView.asLayout.withInsets(
          .init(
            top: $0.y,
            left: $0.x,
            bottom: -$0.y,
            right: -$0.x
          )
        )
      }
    }
  }
}
