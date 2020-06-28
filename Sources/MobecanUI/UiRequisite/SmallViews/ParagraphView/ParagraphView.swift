//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class ParagraphView<Value>: UIView {
  
  public var title: Binder<String?> { titleLabel.rx.text }
  public var attributedTitle: Binder<NSAttributedString?> { titleLabel.rx.attributedText }
  
  @RxUiInput(nil) public var body: AnyObserver<Value?>
  @RxUiInput(true) public var hidesWhenBodyIsNil: AnyObserver<Bool>

  private let titleLabel: UILabel
  
  private let disposeBag = DisposeBag()
    
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(titleLabel: UILabel,
              content: ParagraphViewContent<Value>,
              spacing: CGFloat,
              hidesWhenBodyIsNil: Bool = false) {
    self.titleLabel = titleLabel
  
    super.init(frame: .zero)
    
    putSubview(
      .vstack(spacing: spacing, [titleLabel, content.bodyView])
    )
    
    self.hidesWhenBodyIsNil.onNext(hidesWhenBodyIsNil)
    
    displayValue(body: content.body)
  }
  
  private func displayValue(body: AnyObserver<Value?>) {
    let uniqueId = String(UUID().uuidString.prefix(4))
    
    _body
      .debug("Paragraph-View-Body---\(uniqueId)-\(Value.self)")
      .bind(to: body).disposed(by: disposeBag)

    _body.map { $0 == nil }
      .and(that: _hidesWhenBodyIsNil)
      .debug("Paragraph-View-Should-Be-Hidden---\(uniqueId)-\(Value.self)")
      .bind(to: rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  override public var forFirstBaselineLayout: UIView {
    return titleLabel
  }
}
