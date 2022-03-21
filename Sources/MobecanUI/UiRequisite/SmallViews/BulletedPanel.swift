// Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxSwift
import UIKit


public class BulletedPanel: UIView {
  
  @RxUiInput(false) public var hidesWhenEmpty: AnyObserver<Bool>
  @RxUiInput(nil) public var text: AnyObserver<String?>
  
  private let icon: UIImageView
  private let label: UILabel
  
  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(icon: UIImageView,
              label: UILabel,
              alignment: IconTextAlignment = .xHeight,
              spacing: CGFloat,
              insets: UIEdgeInsets,
              hidesWhenEmpty: Bool = false) {
    self.icon = icon
    self.label = label
    
    super.init(frame: .zero)
    
    addSubviews(alignment: alignment, spacing: spacing, insets: insets)
    
    displayText()
    
    self.hidesWhenEmpty.onNext(hidesWhenEmpty)
  }
  
  private func addSubviews(alignment: IconTextAlignment,
                           spacing: CGFloat,
                           insets: UIEdgeInsets) {
    putSubview(
      UIView.hstack(
        alignment: alignment,
        spacing: spacing,
        icon: icon,
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
