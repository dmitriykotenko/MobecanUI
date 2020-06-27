//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension String {
  
  func width(forFont font: UIFont) -> CGFloat {
    let boundingBox = self.boundingRect(
      with: CGSize(width: .greatestFiniteMagnitude, height: font.lineHeight),
      options: .usesLineFragmentOrigin,
      attributes: [.font: font],
      context: nil
    )
    
    return ceil(boundingBox.height)
  }

  func height(forWidth width: CGFloat,
              font: UIFont) -> CGFloat {
    let boundingBox = self.boundingRect(
      with: CGSize(width: width, height: .greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: [.font: font],
      context: nil
    )
    
    return ceil(boundingBox.height)
  }
}
