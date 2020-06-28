//  Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import RxCocoa
import RxSwift
import UIKit


open class SummaryView<Value, Labels: LabelsGrid>: UIView, EventfulView, DataView {
  
  public typealias ViewEvent = Tap<Value>
  
  public struct IconAndTexts: Equatable {
    public let icon: Image?
    public let texts: Labels.Texts
    
    public init(icon: Image?,
                texts: Labels.Texts) {
      self.icon = icon
      self.texts = texts
    }
  }
  
  @RxUiInput(nil) public var value: AnyObserver<Value?>

  public var viewEvents: Observable<Tap<Value>> {
    rx.tapGesture().when(.recognized)
      .withLatestFrom(_value.filterNil())
      .map { Tap($0) }
  }

  private let iconContainer: ImageViewContainer
  private let labels: Labels
  private let backgroundView: UIView?

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(iconContainer: ImageViewContainer,
              labels: Labels,
              backgroundView: UIView? = nil,
              spacing: CGFloat,
              insets: UIEdgeInsets) {
    self.iconContainer = iconContainer
    self.labels = labels
    self.backgroundView = backgroundView
    
    super.init(frame: .zero)
    
    addSubviews(spacing: spacing, insets: insets)
    bindToInputs()
    highlightOnTaps(disposeBag: disposeBag)
  }

  private func addSubviews(spacing: CGFloat,
                           insets: UIEdgeInsets) {
    backgroundView.map { putSubview($0) }
    
    putSubview(
      .hstack(
        alignment: .fill,
        spacing: spacing,
        [iconContainer.containerView, .vstack([labels.view(), .stretchableSpacer()])],
        insets: insets
      )
    )

    /// Align image to labels if necessary.
    iconContainer.alignImage(inside: self)
  }
  
  private func bindToInputs() {
    let iconAndTexts = _value
      .flatMapLatest { [weak self] in self?.formatValue($0) ?? .never() }

    iconAndTexts
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] in
        self?.displayValue(iconAndTexts: $0)
      })
      .disposed(by: disposeBag)
  }
  
  private func displayValue(iconAndTexts: IconAndTexts?) {
    iconContainer.display(image: iconAndTexts?.icon)
    (iconAndTexts?.texts).map { labels.display(texts: $0) }
  }
 
  /// Override this method to fill labels and iconView according to given value.
  open func formatValue(_ value: Value?) -> Observable<IconAndTexts?> {
    return .just(nil)
  }
  
  open override var forFirstBaselineLayout: UIView { labels.firstBaselineLabel }
  open override var forLastBaselineLayout: UIView { labels.lastBaselineLabel }
}
