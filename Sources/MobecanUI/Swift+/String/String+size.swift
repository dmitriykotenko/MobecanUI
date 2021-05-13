//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension String {
  
  func width(forFont font: UIFont) -> CGFloat {
    ceil(unroundedWidth(forFont: font))
  }

  func unroundedWidth(forFont font: UIFont) -> CGFloat {
    let boundingBox = self.boundingRect(
      with: CGSize(width: .greatestFiniteMagnitude, height: font.lineHeight),
      options: .usesLineFragmentOrigin,
      attributes: [.font: font],
      context: nil
    )

    return boundingBox.width
  }

  func height(forWidth width: CGFloat,
              font: UIFont) -> CGFloat {
    ceil(unroundedHeight(forWidth: width, font: font))
  }

  func unroundedHeight(forWidth width: CGFloat,
                       font: UIFont) -> CGFloat {
    let boundingBox = self.boundingRect(
      with: CGSize(width: width, height: .greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: [.font: font],
      context: nil
    )

    return boundingBox.height
  }
}
