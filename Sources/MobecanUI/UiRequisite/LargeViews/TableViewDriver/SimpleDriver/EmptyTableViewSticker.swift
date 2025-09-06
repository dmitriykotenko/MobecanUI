// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class EmptyTableViewSticker: UITableViewHeaderFooterView, HeightAwareView {

  open var height: CGFloat = 0 { didSet { initIfNeeded() } }

  private var mainSubview: UIView?

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
  }

  private func initIfNeeded() {
    // Устанавливаем прозрачный фон.
    backgroundView = UIView()
    mainSubview = UIView.spacer(height: height)
    mainSubview.map(contentView.addSubview)
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    mainSubview?.sizeThatFits(size) ?? frame.size
  }

  override open func layoutSubviews() {
    initIfNeeded()

    super.layoutSubviews()

    mainSubview?.frame = contentView.bounds

    mainSubview?.setNeedsLayout()
    mainSubview?.layoutIfNeeded()
  }

  open func heightFor(value: EVoid,
                      width: CGFloat) -> CGFloat {
    height
  }
}
