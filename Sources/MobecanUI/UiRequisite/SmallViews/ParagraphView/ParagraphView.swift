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

  /// The only reason this initializer is implemented is avoding of crashes
  /// in some elaborate scenarios. You can override and use it in subclasses,
  /// but you usually do not need to explicitly call it on ParagraphView itself.
  ///
  /// Scenarios are the following:
  ///
  /// 1. Parameterless init() is needed to avoid crash in the following code:
  /// func dangerousInit<View: UIView>() -> View { View() }
  /// let v: ParagraphView<Int> = dangerousInit()
  ///
  /// 2. More complex case. Suppose that you have a subclass of ParagraphView, SubclassedParagraphView.
  /// You implement parameterless init() for this subclass, but you do not implement
  /// parameterless init() for ParagraphView.
  /// Then, the following code will also crash:
  /// func dangerousInit<View: UIView>() -> View { View() }
  /// let v: SubclassedParagraphView = dangerousInit()
  ///
  /// To avoid these kinds of crashes, we require that every subclass of ParagraphView
  /// has explicitly declared parameterless init().
  public required init() {
    self.titleLabel = UILabel()
    super.init(frame: .zero)
  }
  
  public init(titleLabel: UILabel,
              content: ParagraphViewContent<Value>,
              spacing: CGFloat,
              insets: UIEdgeInsets = .zero,
              hidesWhenBodyIsNil: Bool = false) {
    self.titleLabel = titleLabel
  
    super.init(frame: .zero)

    disableTemporaryConstraints()
    
    putSubview(
      .vstack(spacing: spacing, [titleLabel, content.bodyView]),
      insets: insets
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
  
  override public var forFirstBaselineLayout: UIView { titleLabel }
}
