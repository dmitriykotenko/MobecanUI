// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


open class PseudoButton<Value>: LayoutableView, SizableView, DataView {
  
  public typealias ViewEvent = Tap<Void>
  
  @RxUiInput(nil) open var value: AnyObserver<Value?>

  @RxDriverOutput(nil) open var valueGetter: Driver<Value?>
  
  open private(set) var tap: Observable<Void> = .never()

  open var sizer = ViewSizer()

  private let insets: UIEdgeInsets
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(_ subview: UIView,
              insets: UIEdgeInsets = .zero,
              valueSetter: AnyObserver<Value?>,
              tap: Observable<Void>? = nil) {
    self.insets = insets

    super.init()

    setupLayout(subview)
    setupTaps(tap: tap)
    setupValue(setter: valueSetter)
  }

  private func setupLayout(_ subview: UIView) {
    inheritContentHuggingPriority(from: subview)

    updateLayout(subview: subview)

    disposeBag {
      sizer.didChange ==> { [weak self] in self?.updateLayout(subview: subview) }
    }
  }

  private func updateLayout(subview: UIView) {
    layout = sizer.layout(
      sublayout: InsetLayout<UIView>.fromSingleSubview(
        subview,
        insets: insets
      )
    )

    addSubview(subview)
  }

  private func setupTaps(tap: Observable<Void>?) {
    self.tap = tap ?? rx.tapGesture().when(.recognized).mapToVoid()
  }

  private func setupValue(setter: AnyObserver<Value?>) {
    disposeBag {
      _value ==> setter
      _value ==> _valueGetter
    }
  }
  
  public convenience init(button: UIButton,
                          rxFormat: @escaping (Value?) -> Observable<ButtonForeground>) {
    let subject = BehaviorSubject<Value?>(value: nil)
    
    self.init(
      button,
      valueSetter: subject.asObserver(),
      tap: button.rx.tap.asObservable()
    )

    disposeBag {
      subject.flatMap(rxFormat) ==> button.rx.foreground()
    }
  }

  public convenience init(button: UIButton,
                          format: @escaping (Value?) -> ButtonForeground) {
    self.init(
      button: button,
      rxFormat: { .just(format($0)) }
    )
  }

  public convenience init(label: UILabel,
                          insets: UIEdgeInsets = .zero,
                          rxFormat: @escaping (Value?) -> Observable<String?>) {
    let subject = BehaviorSubject<Value?>(value: nil)

    self.init(
      label,
      insets: insets,
      valueSetter: subject.asObserver()
    )

    disposeBag {
      subject.flatMap(rxFormat) ==> label.rx.text
    }
  }

  public convenience init(label: UILabel,
                          insets: UIEdgeInsets = .zero,
                          format: @escaping (Value?) -> String?) {
    self.init(
      label: label,
      insets: insets,
      rxFormat: { .just(format($0)) }
    )
  }

  @discardableResult
  open func setupTouchReaction(onTouchDown: @escaping () -> Void,
                               onTouchUp: @escaping () -> Void) -> Self {
    setupTouchReaction(
      onTouchDown: onTouchDown,
      onTouchUp: onTouchUp,
      disposeBag: disposeBag
    )
    return self
  }

  @discardableResult
  open func highlightOnTaps() -> Self {
    highlightOnTaps(disposeBag: disposeBag)
    return self
  }

  override open var forFirstBaselineLayout: UIView {
    subviews[0].forFirstBaselineLayout
  }

  override open var forLastBaselineLayout: UIView {
    subviews[0].forLastBaselineLayout
  }
}
