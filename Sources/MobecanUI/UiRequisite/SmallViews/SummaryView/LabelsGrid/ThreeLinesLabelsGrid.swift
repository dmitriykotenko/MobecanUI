//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct ThreeLinesLabelsGrid: LabelsGrid {
  
  public struct Spacing {
    
    public let vertical: CGFloat
    public let horizontal: CGFloat
    
    public init(vertical: CGFloat,
                horizontal: CGFloat) {
      self.vertical = vertical
      self.horizontal = horizontal
    }
    
    public static let zero = Spacing(vertical: 0, horizontal: 0)
  }

  public struct Texts: Equatable {
    public let top: String?
    public let topRight: String?
    public let middle: String?
    public let bottom: String?
    
    public init(top: String?,
                topRight: String?,
                middle: String?,
                bottom: String?) {
      self.top = top
      self.topRight = topRight
      self.middle = middle
      self.bottom = bottom
    }
  }

   let topLabel: UILabel
   let topRightLabel: UILabel
   let middleLabel: UILabel
   let bottomLabel: UILabel
  
  private let spacing: Spacing
  
  public init(topLabel: UILabel,
              topRightLabel: UILabel,
              middleLabel: UILabel,
              bottomLabel: UILabel,
              spacing: Spacing) {
    self.topLabel = topLabel
    self.topRightLabel = topRightLabel
    self.middleLabel = middleLabel
    self.bottomLabel = bottomLabel
    
    self.spacing = spacing
  }
  
  public static var empty = ThreeLinesLabelsGrid(
    topLabel: UILabel(),
    topRightLabel: UILabel(),
    middleLabel: UILabel(),
    bottomLabel: UILabel(),
    spacing: .zero
  )
  
  public func view() -> UIView {
    _ = topRightLabel.fitToContent(axis: [.horizontal])
    
    return .autolayoutVstack(
      spacing: spacing.vertical,
      [
        .autolayoutHstack(
          alignment: .firstBaseline,
          distribution: .fill,
          spacing: spacing.horizontal,
          [topLabel, topRightLabel]
        ),
        middleLabel,
        bottomLabel
      ]
    )
  }
  
  public func display(texts: Texts) {
    topLabel.text = texts.top
    topRightLabel.text = texts.topRight
    middleLabel.text = texts.middle
    bottomLabel.text = texts.bottom
  }
  
  public var firstBaselineLabel: UIView { topLabel }
  public var lastBaselineLabel: UIView { bottomLabel }
}
