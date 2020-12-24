//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class PseudoButton<Value>: UIView, DataView {
  
  public typealias ViewEvent = Tap<Void>
  
  @RxUiInput(nil) public var value: AnyObserver<Value?>

  @RxDriverOutput(nil) public var valueGetter: Driver<Value?>
  
  public private(set) var tap: Observable<Void> = .never()
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(_ subview: UIView,
              insets: UIEdgeInsets = .zero,
              valueSetter: AnyObserver<Value?>,
              tap: Observable<Void>? = nil) {
    super.init(frame: .zero)

    addSubviews(subview, insets: insets)
    setupTaps(tap: tap)
    setupValue(setter: valueSetter)
  }

  private func addSubviews(_ subview: UIView,
                           insets: UIEdgeInsets) {
    addSubview(subview)

    subview.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(insets).priority(900)

      $0.top.greaterThanOrEqualToSuperview().inset(insets.top)
      $0.bottom.lessThanOrEqualToSuperview().inset(insets.bottom)
      $0.left.greaterThanOrEqualToSuperview().inset(insets.left)
      $0.right.lessThanOrEqualToSuperview().inset(insets.right)
    }
  }

  private func setupTaps(tap: Observable<Void>?) {
    self.tap = tap ?? rx.tapGesture().when(.recognized).mapToVoid()
  }

  private func setupValue(setter: AnyObserver<Value?>) {
    _value.bind(to: setter).disposed(by: disposeBag)
    _value.bind(to: _valueGetter).disposed(by: disposeBag)
  }
  
  public convenience init(button: UIButton,
                          rxFormat: @escaping (Value?) -> Observable<ButtonForeground>) {
    let subject = BehaviorSubject<Value?>(value: nil)
    
    self.init(
      button,
      valueSetter: subject.asObserver(),
      tap: button.rx.tap.asObservable()
    )
    
    subject
      .flatMap(rxFormat)
      .bind(to: button.rx.foreground())
      .disposed(by: disposeBag)
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

    subject
      .flatMap(rxFormat)
      .bind(to: label.rx.text)
      .disposed(by: disposeBag)
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
}
