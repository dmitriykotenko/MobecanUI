//  Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import RxCocoa
import RxSwift
import UIKit


open class SummaryView<Value, Labels: LabelsGrid>: UIView, EventfulView, DataView {
  
  public typealias ViewEvent = Tap<Value>

  public struct IconAndTexts: Equatable {
    public let iconUrl: URL?
    public let texts: Labels.Texts
    
    public init(iconUrl: URL?,
                texts: Labels.Texts) {
      self.iconUrl = iconUrl
      self.texts = texts
    }
  }
  
  @RxUiInput(nil) public var value: AnyObserver<Value?>

  public var viewEvents: Observable<Tap<Value>> {
    privateTap.withLatestFrom(_value.filterNil()).map { Tap($0) }
  }
  
  private lazy var privateTap = rx.tapGesture().when(.recognized).share()

  private let iconView: UIImageView
  private let iconPlaceholder: UIImage?

  private let labels: Labels
  private let backgroundView: UIView

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public override init(frame: CGRect) {
    self.iconView = UIImageView()
    self.iconPlaceholder = nil
    self.labels = .empty
    self.backgroundView = UIView()
    
    super.init(frame: .zero)
    
    addSubviews(spacing: 0, insets: .zero)
    bindToInputs()
    highlightOnTaps(disposeBag: disposeBag)
  }
  
  public init(iconView: UIImageView,
              iconPlaceholder: UIImage? = nil,
              labels: Labels,
              backgroundView: UIView,
              spacing: CGFloat,
              insets: UIEdgeInsets) {
    self.iconView = iconView
    self.iconPlaceholder = iconPlaceholder
    self.labels = labels
    self.backgroundView = backgroundView
    
    super.init(frame: .zero)
    
    addSubviews(spacing: spacing, insets: insets)
    bindToInputs()
    highlightOnTaps(disposeBag: disposeBag)
  }

  private func addSubviews(spacing: CGFloat,
                           insets: UIEdgeInsets) {
    putSubview(
      .zstack([
        backgroundView,
        .hstack(
          alignment: .top,
          spacing: spacing,
          [iconView, labels.view()],
          insets: insets
        )
      ])
    )
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
    if let iconUrl = iconAndTexts?.iconUrl {
      iconView.kf.setImage(with: iconUrl, placeholder: iconPlaceholder)
    } else {
      iconView.image = iconPlaceholder
    }
    
    (iconAndTexts?.texts).map { labels.display(texts: $0) }
  }
 
  /// Override this method to fill labels and iconView according to given value.
  open func formatValue(_ value: Value?) -> Observable<IconAndTexts?> {
    return .just(nil)
  }
}
