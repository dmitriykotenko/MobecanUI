//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class SimpleTableViewSticker: UITableViewHeaderFooterView, HeightAwareView {

  open var initLabel: () -> UILabel = { UILabel() }
  open var labelInsets: UIEdgeInsets = .zero
  open var textFromHeader: (SimpleTableViewHeader) -> String = { "\($0)" }

  private var mainSubview: UIView?

  private var label: UILabel?

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
  }
  
  open func displayValue(_ value: SimpleTableViewHeader??) {
    initIfNeeded()
    
    // 'value' is double optional.
    // We need .flatten() to transform it to single optional.
    let header = value.flatten()
      
    label?.text = header.map(textFromHeader)
  }

  private func initIfNeeded() {
    guard label == nil else { return }
    
    label = initLabel()
    
    label.map(initWithLabel)
  }

  private func initWithLabel(_ label: UILabel) {
    // Set transparent background.
    backgroundView = UIView()
    
    mainSubview = UIView.zstack([label], insets: labelInsets)
    
    mainSubview.map(contentView.addSubview)
  }

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    initIfNeeded()

    return mainSubview?.sizeThatFits(size) ?? frame.size
  }

  override open func layoutSubviews() {
    initIfNeeded()

    super.layoutSubviews()

    mainSubview?.frame = contentView.bounds

    mainSubview?.setNeedsLayout()
    mainSubview?.layoutIfNeeded()
  }

  open func heightFor(value: SimpleTableViewHeader?,
                      width: CGFloat) -> CGFloat {
    initIfNeeded()
    
    let headerText = value.map(textFromHeader)
    
    let labelHeight = headerText.flatMap { text in
      label?.font.map { font in
        text.height(forWidth: width, font: font)
      }
    }
    
    let totalHeight = labelHeight.map { $0 + labelInsets.top + labelInsets.bottom }
    
    return totalHeight ?? 0
  }
}
