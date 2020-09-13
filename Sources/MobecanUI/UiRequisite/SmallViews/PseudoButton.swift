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
    setupValueSetter(valueSetter)
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

  private func setupValueSetter(_ valueSetter: AnyObserver<Value?>) {
    _value.bind(to: valueSetter).disposed(by: disposeBag)
  }
  
  public convenience init(button: UIButton,
                          format: @escaping (Value) -> ButtonForeground) {
    let subject = PublishSubject<Value?>()
    
    self.init(
      button,
      valueSetter: subject.asObserver(),
      tap: button.rx.tap.asObservable()
    )
    
    subject
      .nestedMap(transform: format)
      .filterNil()
      .bind(to: button.rx.foreground())
      .disposed(by: disposeBag)
  }
  
  public convenience init(label: UILabel,
                          insets: UIEdgeInsets = .zero,
                          format: @escaping (Value) -> String?) {
    let subject = PublishSubject<Value?>()
    
    self.init(
      label,
      insets: insets,
      valueSetter: subject.asObserver()
    )
    
    subject
      .nestedFlatMap(transform: format)
      .bind(to: label.rx.text)
      .disposed(by: disposeBag)
  }
}
