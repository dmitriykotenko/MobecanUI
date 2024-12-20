// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public class BulletedPanel: LayoutableView {

  @RxUiInput(false) public var hidesWhenEmpty: AnyObserver<Bool>
  @RxUiInput(nil) public var text: AnyObserver<String?>
  
  private let bulletView: UIView
  private let label: UILabel
  
  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(bulletView: UIView,
              label: UILabel,
              alignment: BulletToTextAlignment = .xHeight,
              spacing: CGFloat,
              insets: UIEdgeInsets,
              hidesWhenEmpty: Bool = false) {
    self.bulletView = bulletView
    self.label = label
    
    super.init()
    
    addSubviews(alignment: alignment, spacing: spacing, insets: insets)
    
    displayText()
    
    self.hidesWhenEmpty.onNext(hidesWhenEmpty)
  }
  
  private func addSubviews(alignment: BulletToTextAlignment,
                           spacing: CGFloat,
                           insets: UIEdgeInsets) {
    layout = BoilerplateLayout(
      .hstack(
        alignment: alignment,
        spacing: spacing,
        bulletView: bulletView,
        label: label,
        insets: insets
      )
    )
  }
  
  private func displayText() {
    disposeBag {
      _text ==> label.rx.text

      _text
        .withLatestFrom(_hidesWhenEmpty) { $0.isNilOrEmpty && $1 }
        ==> rx.isHidden
    }
  }
}
