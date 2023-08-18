// Copyright © 2021 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


open class ViewSizer {

  open var minimumWidth: CGFloat? { didSet { _didChange.onNext(()) } }
  open var minimumHeight: CGFloat? { didSet { _didChange.onNext(()) } }

  open var maximumWidth: CGFloat? { didSet { _didChange.onNext(()) } }
  open var maximumHeight: CGFloat? { didSet { _didChange.onNext(()) } }

  open var mustStretchHorizontally: Bool = false { didSet { _didChange.onNext(()) } }
  open var mustStretchVertically: Bool = false { didSet { _didChange.onNext(()) } }

  /// Нужно ли при вёрстке укладываться в контейнер по ширине.
  ///
  /// Свойство имеет больший приоритет, чем свойство ``minimumWidth``.
  ///
  /// Если при вызове метода ``sizeThatFits(_:nativeSizing:)`` окажется,
  /// что `mustRespectWidthToFit == true` и `minimumWidth >= sizeToFit.width`,
  /// то для финальная ширина будет равна `sizeToFit.width`.
  ///
  /// Значение по умолчанию — `false`.
  open var mustRespectWidthToFit: Bool = false { didSet { _didChange.onNext(()) } }

  /// Нужно ли при вёрстке укладываться в контейнер по высоте.
  ///
  /// Свойство имеет больший приоритет, чем свойство ``minimumHeight``.
  ///
  /// Если при вызове метода ``sizeThatFits(_:nativeSizing:)`` окажется,
  /// что `mustRespectHeightToFit == true` и `minimumHeight >= sizeToFit.height`,
  /// то финальной высота будет равна `sizeToFit.height`.
  ///
  /// Значение по умолчанию — `false`.
  open var mustRespectHeightToFit: Bool = false { didSet { _didChange.onNext(()) } }

  @RxOutput var didChange: Observable<Void>

  public init() {}

  @discardableResult
  open func mustRespectWidthToFit(_ mustRespect: Bool) -> Self {
    self.mustRespectWidthToFit = mustRespect
    return self
  }

  @discardableResult
  open func mustRespectHeightToFit(_ mustRespect: Bool) -> Self {
    self.mustRespectHeightToFit = mustRespect
    return self
  }

  open func sizeThatFits(_ sizeToFit: CGSize,
                         nativeSizing: (CGSize) -> CGSize) -> CGSize {
    let clippedSize = clip(size: sizeToFit)
    let nativeSize = nativeSizing(clippedSize)

    var stretchedSize = nativeSize

    if mustStretchHorizontally { stretchedSize.width = sizeToFit.width }
    if mustStretchVertically { stretchedSize.height = sizeToFit.height }

    return clip(size: stretchedSize).bounded(
      by: boundsToRespect(sizeToFit: sizeToFit)
    )
  }

  private func clip(size: CGSize) -> CGSize {
    var result = size

    minimumWidth.map { result.width = max(result.width, $0) }
    minimumHeight.map { result.height = max(result.height, $0) }

    maximumWidth.map { result.width = min(result.width, $0) }
    maximumHeight.map { result.height = min(result.height, $0) }

    return result
  }

  private func boundsToRespect(sizeToFit: CGSize) -> CGSize {
    .init(
      width: mustRespectWidthToFit ? sizeToFit.width : .greatestFiniteMagnitude,
      height: mustRespectHeightToFit ? sizeToFit.height : .greatestFiniteMagnitude
    )
  }

  open func layout(sublayout: Layout) -> Layout {
    SizeLayout<UIView>(
      minWidth: minimumWidth,
      maxWidth: maximumWidth,
      minHeight: minimumHeight,
      maxHeight: maximumHeight,
      sublayout: sublayout
    )
  }
}
