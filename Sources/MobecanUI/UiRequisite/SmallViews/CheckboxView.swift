//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class CheckboxView<NestedValue>: UIView, DataView, EventfulView {
  
  public typealias Value = IsSelected<NestedValue>
  public typealias ViewEvent = Tap<Value>

  @RxUiInput(nil) public var value: AnyObserver<Value?>

  public var viewEvents: Observable<Tap<Value>> {
    rx.tapGesture().when(.recognized)
      .withLatestFrom(_value.filterNil())
      .map { Tap($0) }
  }

  private let checkmark: CheckmarkView
  private let label: UILabel

  private let formatValue: (NestedValue?) -> Observable<NSAttributedString?>
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(checkmark: CheckmarkView,
              label: UILabel,
              formatValue: @escaping (NestedValue?) -> Observable<NSAttributedString?>,
              height: CGFloat,
              insets: UIEdgeInsets) {
    self.checkmark = checkmark
    self.label = label
    self.formatValue = formatValue
    
    super.init(frame: .zero)
    
    setupHeight(height)
    addSubviews(insets: insets)
    displayValue()
    
    highlightOnTaps(disposeBag: disposeBag)
  }
  
  private func setupHeight(_ height: CGFloat) {
    _ = self.height(height)
  }
  
  private func addSubviews(insets: UIEdgeInsets) {
    putSubview(
      .hstack(
        alignment: .top,
        [checkmark, label]
      ),
      insets: insets
    )
  }
  
  private func displayValue() {
    disposeBag {
      _value.compactMap { $0?.isSelected } ==> checkmark.setIsSelected

    _value
      .weakFlatMapLatest(self) { $1.formatValue($0?.value) } ==> label.rx.attributedText
    }
  }
}


public extension CheckboxView {

  convenience init(checkmark: CheckmarkView,
                   label: UILabel,
                   formatValue: @escaping (NestedValue?) -> String?,
                   height: CGFloat,
                   insets: UIEdgeInsets) {
    self.init(
      checkmark: checkmark,
      label: label,
      formatValue: {
        .just(formatValue($0).map { .plain($0) })
      },
      height: height,
      insets: insets
    )
  }

  convenience init(checkmark: CheckmarkView,
                   label: UILabel,
                   formatValue: @escaping (NestedValue?) -> NSAttributedString?,
                   height: CGFloat,
                   insets: UIEdgeInsets) {
    self.init(
      checkmark: checkmark,
      label: label,
      formatValue: { .just(formatValue($0)) },
      height: height,
      insets: insets
    )
  }
}
