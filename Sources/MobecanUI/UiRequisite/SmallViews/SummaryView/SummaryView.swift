//  Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import LayoutKit
import RxCocoa
import RxSwift
import UIKit


open class SummaryView<Value, Labels: LabelsGrid>: LayoutableView, EventfulView, DataView {
  
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

  /// The only reason this initializer is implemented is avoding of crashes
  /// in some elaborate scenarios. You can override and use it in subclasses,
  /// but you usually do not need to explicitly call it on SummaryView itself.
  ///
  /// Scenarios are the following:
  /// 
  /// 1. Parameterless init() is needed to avoid crash in the following code:
  /// func dangerousInit<View: UIView>() -> View { View() }
  /// let v: SummaryView<Int, ThreeLinesLabelsGrid> = dangerousInit()
  ///
  /// 2. More complex case. Suppose that you have a subclass of SummaryView, SubclassedSummaryView.
  /// You implement parameterless init() for this subclass, but you do not implement
  /// parameterless init() for SummaryView.
  /// Then, the following code will also crash:
  /// func dangerousInit<View: UIView>() -> View { View() }
  /// let v: SubclassedSummaryView = dangerousInit()
  ///
  /// To avoid these kinds of crashes, we require that every subclass of SummaryView
  /// has explicitly declared parameterless init().
  override public required init() {
    self.iconContainer = .init(imageView: .init(), containerView: .init())
    self.labels = .empty
    self.backgroundView = nil

    super.init()
  }
  
  public init(iconContainer: ImageViewContainer,
              labels: Labels,
              backgroundView: UIView? = nil,
              spacing: CGFloat,
              insets: UIEdgeInsets) {
    self.iconContainer = iconContainer
    self.labels = labels
    self.backgroundView = backgroundView
    
    super.init()
    
    setupLayout(spacing: spacing, insets: insets)
    bindToInputs()
    highlightOnTaps(disposeBag: disposeBag)
  }

  private func setupLayout(spacing: CGFloat,
                           insets: UIEdgeInsets) {
    layout = .fromView(
      .zstack(
        [
//          backgroundView,
          .hstack(
            alignment: .fill,
            spacing: spacing,
            [
              iconContainer.containerView,
              labels.view()
            ],
            insets: insets
          )
        ]
        .filterNil()
      )
    )
  }
  
  private func bindToInputs() {
    let iconAndTexts = _value
      .flatMapLatest { [weak self] in self?.formatValue($0) ?? .never() }

    disposeBag {
      iconAndTexts.distinctUntilChanged() ==> { [weak self] in
        self?.displayValue(iconAndTexts: $0)
      }
    }
  }
  
  private func displayValue(iconAndTexts: IconAndTexts?) {
    iconContainer.display(image: iconAndTexts?.icon)
    (iconAndTexts?.texts).map { labels.display(texts: $0) }
  }
 
  /// Override this method to fill labels and iconView according to given value.
  open func formatValue(_ value: Value?) -> Observable<IconAndTexts?> {
    .just(nil)
  }
  
  override open var forFirstBaselineLayout: UIView { labels.firstBaselineLabel }
  override open var forLastBaselineLayout: UIView { labels.lastBaselineLabel }
}
