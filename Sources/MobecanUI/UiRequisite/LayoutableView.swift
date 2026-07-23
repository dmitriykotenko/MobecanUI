// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import UIKit


open class LayoutableView: UIView {

  open var isClickThroughEnabled: Bool = false

  open var layout: Layout {
    didSet {
      removeAllSubviews()
      updateContentHuggingPriority()
      if window != nil { setNeedsLayoutAndPropagate() }
    }
  }

  private var visibilityListeners: [NSKeyValueObservation] = []
  private var derivedIsVisible: (() -> Bool)?

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init() {
    self.layout = EmptyLayout()

    super.init(frame: .zero)
  }

  public convenience init(layout: Layout) {
    self.init()
    self.layout = layout
    self.updateContentHuggingPriority()
  }

  private func updateContentHuggingPriority() {
    setContentHuggingPriority(.from(layout.flexibility.horizontal), for: .horizontal)
    setContentHuggingPriority(.from(layout.flexibility.vertical), for: .vertical)
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    return layout.measurement(within: size).size
  }

  override open func layoutSubviews() {
    layout.measurement(within: bounds.size).arrangement(within: bounds).makeViews(in: self)
  }

  override open func hitTest(_ point: CGPoint,
                             with event: UIEvent?) -> UIView? {
    let hit = super.hitTest(point, with: event)

    switch hit {
    case self where isClickThroughEnabled: return nil
    default: return hit
    }
  }

  @discardableResult
  open func isClickThroughEnabled(_ isClickThroughEnabled: Bool) -> Self {
    self.isClickThroughEnabled = isClickThroughEnabled
    return self
  }

  /// Делает вьюшку прозрачной для прикосновений.
  ///
  /// Полностью аналогичен `isClickThroughEnabled(true)`, но записывается короче.
  @discardableResult
  open func clickThrough() -> Self {
    self.isClickThroughEnabled = true
    return self
  }

  /// Автоматически подстраивает видимость вьюшки под видимости других указанных вьюшек:
  /// каждый раз, когда у любой вьюшки из массива `views` меняется видимость,
  /// видимость текущей вьюшки пересчитывается по формуле, указанной в `condition`.
  ///
  /// - Parameters:
  ///   - views: Вьюшки, на основе которых надо подстраивать видимость.
  ///   - condition: Определяет, как видимость текущей вьюшки зависит от видимостей вьюшек, указанных в `derivedFromViews`.
  ///
  /// - Warning: Если включена автоподстройка видимости,
  /// опасно использовать ручное управление флагами `isVisible` и `isHidden`,
  /// потому что будет сложно предсказать итоговую видимость.
  ///
  /// Пример использования:
  /// ```
  /// let stackView = UIView.hstack(memberViews)
  ///
  /// stackView.withVisibility(derivedFromViews: memberViews) { members in
  ///   members.contains(\.isVisible)
  /// }
  /// ```
  @discardableResult
  open func withVisibility(derivedFromViews views: [UIView],
                           condition: @escaping ([UIView]) -> Bool) -> Self {
    visibilityListeners = []
    derivedIsVisible = { condition(views) }

    visibilityListeners = views.map { view in
      view.observe(\.isHidden, options: [.initial, .new]) { [weak self] _, _ in
        self?.updateDerivedVisibility()
      }
    }

    updateDerivedVisibility()

    return self
  }

  /// Автоматически подстраивает видимость вьюшки под видимость другой указанной вьюшки:
  /// когда `view` становится скрытым, скрывает текущую вьюшку,
  /// когда `view` становится видимым, показывает текущую вьюшку.
  ///
  /// - Parameters:
  ///   - view: Вьюшка, на основе которой будет подстраиваться видимость
  ///
  /// - Warning: Если включена автоподстройка видимости,
  /// опасно использовать ручное управление флагами `isVisible` и `isHidden`,
  /// потому что будет сложно предсказать итоговую видимость.
  @discardableResult
  open func withVisibility(derivedFrom view: UIView) -> Self {
    withVisibility(derivedFromViews: [view]) {
      $0.first?.isVisible == true
    }
  }

  /// Выключает установленную ранее автоматическую подстройку видимости.
  @discardableResult
  open func withoutDerivedVisibility() -> Self {
    visibilityListeners = []
    derivedIsVisible = nil
    return self
  }

  private func updateDerivedVisibility() {
    if let newIsVisible = derivedIsVisible?(), isVisible != newIsVisible {
      isVisible = newIsVisible
    }
  }
}


private extension UILayoutPriority {

  static func from(_ flex: Flexibility.Flex) -> UILayoutPriority {
    flex.map { UILayoutPriority(rawValue: Float(-$0).clipped(inside: 0...999)) }
    ?? .required
  }
}
