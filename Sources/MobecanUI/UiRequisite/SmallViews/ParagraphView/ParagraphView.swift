//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class ParagraphView<Value>: UIView {
  
  @RxUiInput(nil) public var title: AnyObserver<String?>
  @RxUiInput(nil) public var attributedTitle: AnyObserver<NSAttributedString?>
  
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
              titleInsets: UIEdgeInsets = .zero,
              contentInsets: UIEdgeInsets = .zero,
              hidesWhenBodyIsNil: Bool = false) {
    self.titleLabel = titleLabel

    super.init(frame: .zero)

    disableTemporaryConstraints()

    putSubview(
      .vstack(
        spacing: spacing,
        [
          titleLabel.withInsets(titleInsets),
          content.bodyView.withInsets(contentInsets)
        ]
      )
    )

    self.hidesWhenBodyIsNil.onNext(hidesWhenBodyIsNil)

    displayTitle()
    displayValue(body: content.body)
  }

  public convenience init(titleLabel: UILabel,
                          content: ParagraphViewContent<Value>,
                          spacing: CGFloat,
                          insets: UIEdgeInsets,
                          hidesWhenBodyIsNil: Bool = false) {
    self.init(
      titleLabel: titleLabel,
      content: content,
      spacing: spacing,
      titleInsets: insets.with(bottom: 0),
      contentInsets: insets.with(top: 0),
      hidesWhenBodyIsNil: hidesWhenBodyIsNil
    )
  }

  private func displayTitle() {
    [
      _title.bind(to: titleLabel.rx.text),
      _attributedTitle.bind(to: titleLabel.rx.attributedText),

      Observable
        .merge(_title.map { $0 != nil }, _attributedTitle.map { $0 != nil })
        .bind(to: titleLabel.rx.isVisible)
    ]
    .disposed(by: disposeBag)
  }

  private func displayValue(body: AnyObserver<Value?>) {
    _body.bind(to: body).disposed(by: disposeBag)

    _body.map { $0 == nil }
      .and(that: _hidesWhenBodyIsNil)
      .bind(to: rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  override public var forFirstBaselineLayout: UIView { titleLabel }
}
