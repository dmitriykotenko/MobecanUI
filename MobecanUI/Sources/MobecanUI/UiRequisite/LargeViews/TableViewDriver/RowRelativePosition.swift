//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct RowRelativePosition {
  
  public let isFirstSection: Bool
  public let isFirstRow: Bool
  public let isLastSection: Bool
  public let isLastRow: Bool
  
  public init(isFirstSection: Bool,
              isFirstRow: Bool,
              isLastSection: Bool,
              isLastRow: Bool) {
    self.isFirstSection = isFirstSection
    self.isFirstRow = isFirstRow
    self.isLastSection = isLastSection
    self.isLastRow = isLastRow
  }

  public init(indexPath: IndexPath,
              of sectionLengths: [Int]) {
    isFirstSection = (indexPath.section == 0)
    isFirstRow = (indexPath.row == 0)
    isLastSection = (indexPath.section == sectionLengths.count - 1)
    isLastRow = (indexPath.row == sectionLengths[indexPath.section] - 1)
  }
  
  public static var empty = RowRelativePosition(
    isFirstSection: false,
    isFirstRow: false,
    isLastSection: false,
    isLastRow: false
  )
}
