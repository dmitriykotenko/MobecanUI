//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct FourLinesLabelsGrid: LabelsGrid {
  
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
    let top: String?
    let topRight: String?
    let firstMiddle: String?
    let secondMiddle: String?
    let bottom: String?
    
    public init(top: String?,
                topRight: String?,
                firstMiddle: String?,
                secondMiddle: String?,
                bottom: String?) {
      self.top = top
      self.topRight = topRight
      self.firstMiddle = firstMiddle
      self.secondMiddle = secondMiddle
      self.bottom = bottom
    }
  }

  let topLabel: UILabel
  let topRightLabel: UILabel
  let firstMiddleLabel: UILabel
  let secondMiddleLabel: UILabel
  let bottomLabel: UILabel
  
  private let spacing: Spacing
  
  public init(topLabel: UILabel,
              topRightLabel: UILabel,
              firstMiddleLabel: UILabel,
              secondMiddleLabel: UILabel,
              bottomLabel: UILabel,
              spacing: Spacing) {
    self.topLabel = topLabel
    self.topRightLabel = topRightLabel
    self.firstMiddleLabel = firstMiddleLabel
    self.secondMiddleLabel = secondMiddleLabel
    self.bottomLabel = bottomLabel
    
    self.spacing = spacing
  }

  public static var empty = FourLinesLabelsGrid(
    topLabel: UILabel(),
    topRightLabel: UILabel(),
    firstMiddleLabel: UILabel(),
    secondMiddleLabel: UILabel(),
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
          distribution: .equalSpacing,
          spacing: spacing.horizontal,
          [topLabel, topRightLabel]
        ),
        firstMiddleLabel,
        secondMiddleLabel,
        bottomLabel
      ]
    )
  }
  
  public func display(texts: Texts) {
    topLabel.text = texts.top
    topRightLabel.text = texts.topRight
    firstMiddleLabel.text = texts.firstMiddle
    secondMiddleLabel.text = texts.secondMiddle
    bottomLabel.text = texts.bottom
  }
  
  public var firstBaselineLabel: UIView { topLabel }
  public var lastBaselineLabel: UIView { bottomLabel }
}
