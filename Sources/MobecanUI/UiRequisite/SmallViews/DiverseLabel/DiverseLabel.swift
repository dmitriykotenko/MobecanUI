//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class DiverseLabel: UILabel, SizableView {

  open var sizer = ViewSizer()

  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.apply(to: super.sizeThatFits(size))
  }

  public override var text: String? {
    didSet { updatePlainText() }
  }

  public override var attributedText: NSAttributedString? {
    didSet { updateAttributedText() }
  }

  open var textTransformer: StringTransformer? = nil

  private func updatePlainText() {
    switch textTransformer {
    case nil, .attributed:
      break
    case .plain(let transform):
      super.text = transform(text)
    case .plainToAttributed(let transform):
      // 1. Get label's default attributes (font size, text color etc.).
      let defaultAttributes = attributedText?.attributes(at: 0, effectiveRange: nil)

      // 2. Transform current text by given transformer.
      let newText = text.flatMap(transform)
        .map { NSMutableAttributedString(attributedString: $0) }

      // 3. Append default attributes to transformed text.
      zip(newText, defaultAttributes).map {
        $0.addAttributes($1, range: NSRange(0..<$0.length))
      }

      super.attributedText = newText
    }
  }

  private func updateAttributedText() {
    switch textTransformer {
    case nil, .plain, .plainToAttributed:
      break
    case .attributed(let transform):
      super.attributedText = attributedText.flatMap(transform)
    }
  }
}
