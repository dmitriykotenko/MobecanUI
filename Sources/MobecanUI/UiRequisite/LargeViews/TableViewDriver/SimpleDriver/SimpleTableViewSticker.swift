//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class SimpleTableViewSticker: UITableViewHeaderFooterView, HeightAwareView {

  public var initLabel: () -> UILabel = { UILabel() }
  public var labelInsets: UIEdgeInsets = .zero
  public var textFromHeader: (SimpleTableViewHeader) -> String = { "\($0)" }

  private var label: UILabel?

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
  }
  
  public func displayValue(_ value: SimpleTableViewHeader??) {
    initIfNeeded()
    
    // 'value' is double optional.
    // We need nested flatMap to transform it to single optional.
    let header = value.flatMap { $0 }
      
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
    
    let mainSubview = UIView.zstack([label], insets: labelInsets)
    
    contentView.addSubview(mainSubview)
    
    mainSubview.snp.makeConstraints {
      // Use .high priority to suppress autolayout warnings.
      //
      // Warnings appear because of contentView's encapsulated layout height constraint.
      // We can not use contentView.translatesAutoresizingMaskIntoConstraints = false,
      // because it will break UITableViewHeaderFooterView's layout.
      $0.edges.equalToSuperview().priority(.high)
    }
  }
  
  public func heightFor(value: SimpleTableViewHeader?,
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
