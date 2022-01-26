// Copyright © 2020 Mobecan. All rights reserved.


public struct SectionRelativePosition {
  
  public let isFirstSection: Bool
  public let isLastSection: Bool
  
  public init(isFirstSection: Bool,
              isLastSection: Bool) {
    self.isFirstSection = isFirstSection
    self.isLastSection = isLastSection
  }

  public init(section sectionIndex: Int,
              of sectionsCount: Int) {
    isFirstSection = (sectionIndex == 0)
    isLastSection = (sectionIndex == sectionsCount - 1)
  }
  
  public static var empty = SectionRelativePosition(
    isFirstSection: false,
    isLastSection: false
  )
}
