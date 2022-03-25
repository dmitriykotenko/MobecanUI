// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class ParagraphView<Value, ViewEvent>: LayoutableView, EventfulView {
  
  @RxUiInput(nil) open var title: AnyObserver<String?>
  @RxUiInput(nil) open var attributedTitle: AnyObserver<NSAttributedString?>
  
  @RxUiInput(nil) open var body: AnyObserver<Value?>
  @RxUiInput(.never()) open var hidesWhenBodyIs: AnyObserver<Predicate<Value?>>

  @RxOutput open var viewEvents: Observable<ViewEvent>

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
  override public required init() {
    self.titleLabel = UILabel()
    super.init()
  }

  public init(titleLabel: UILabel,
              content: ParagraphViewContent<Value, ViewEvent>,
              spacing: CGFloat,
              titleInsets: UIEdgeInsets = .zero,
              contentInsets: UIEdgeInsets = .zero,
              hidesWhenBodyIs: Predicate<Value?> = .never()) {
    self.titleLabel = titleLabel

    super.init()

    layout =
      UIView.vstack(
        spacing: spacing,
        [
          titleLabel.withInsets(titleInsets),
          content.bodyView.withInsets(contentInsets)
        ]
      )
      .asLayout

    self.hidesWhenBodyIs.onNext(hidesWhenBodyIs)

    displayTitle()
    displayValue(body: content.body)

    disposeBag { content.bodyEvents ==> _viewEvents }
  }

  public convenience init(titleLabel: UILabel,
                          content: ParagraphViewContent<Value, ViewEvent>,
                          spacing: CGFloat,
                          insets: UIEdgeInsets,
                          hidesWhenBodyIs: Predicate<Value?> = .never()) {
    self.init(
      titleLabel: titleLabel,
      content: content,
      spacing: spacing,
      titleInsets: insets.with(bottom: 0),
      contentInsets: insets.with(top: 0),
      hidesWhenBodyIs: hidesWhenBodyIs
    )
  }

  private func displayTitle() {
    disposeBag {
      _title ==> titleLabel.rx.text
      _attributedTitle ==> titleLabel.rx.attributedText

      titleLabel.rx.isVisible <==
        .merge(_title.isNotEqual(to: nil), _attributedTitle.isNotEqual(to: nil))
    }
  }

  private func displayValue(body: AnyObserver<Value?>) {
    disposeBag {
      _body ==> body
      rx.isHidden <== .combineLatest(_hidesWhenBodyIs, _body) { $0($1) }
    }
  }

  override open var forFirstBaselineLayout: UIView { titleLabel }
}


extension ParagraphView: MandatorinessListener {

  open var isMandatory: AnyObserver<Bool> {
    (titleLabel as? MandatorinessListener)?.isMandatory ?? .empty
  }
}
