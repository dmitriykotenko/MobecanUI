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

  @RxOutput var didChange: Observable<Void>

  public init() {}

  open func sizeThatFits(_ size: CGSize,
                         nativeSizing: (CGSize) -> CGSize) -> CGSize {
    let clippedSize = clip(size: size)
    let nativeSize = nativeSizing(clippedSize)

    var stretchedSize = nativeSize

    if mustStretchHorizontally { stretchedSize.width = size.width }
    if mustStretchVertically { stretchedSize.height = size.height }

    return clip(size: stretchedSize)
  }

  private func clip(size: CGSize) -> CGSize {
    var result = size

    minimumWidth.map { result.width = max(result.width, $0) }
    minimumHeight.map { result.height = max(result.height, $0) }

    maximumWidth.map { result.width = min(result.width, $0) }
    maximumHeight.map { result.height = min(result.height, $0) }

    return result
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
