// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import UIKit
import LayoutKit


class ScrollViewMiddlemanView: UIView {

  private let contentView: UIView

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(contentView: UIView) {
    self.contentView = contentView

    super.init(frame: .zero)

    addSubview(contentView)
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = contentView.sizeThatFits(size)

    return CGSize(
      width: size.width,
      height: contentSize.height
    )
  }

  override func layoutSubviews() {
    contentView.frame = self.bounds
  }
}
