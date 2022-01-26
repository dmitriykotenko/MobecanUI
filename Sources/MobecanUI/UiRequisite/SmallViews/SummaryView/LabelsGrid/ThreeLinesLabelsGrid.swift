// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct ThreeLinesLabelsGrid: LabelsGrid {

  public struct Subviews {

    let topLabel: UILabel
    let topRightLabel: UILabel
    let middleLabel: UILabel
    let bottomLabel: UILabel

    public init(topLabel: UILabel,
                topRightLabel: UILabel,
                middleLabel: UILabel,
                bottomLabel: UILabel) {
      self.topLabel = topLabel
      self.topRightLabel = topRightLabel
      self.middleLabel = middleLabel
      self.bottomLabel = bottomLabel
    }
  }

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
  private let topRightLabelInsets: UIEdgeInsets
  
  public init(subviews: Subviews,
              spacing: Spacing,
              topRightLabelInsets: UIEdgeInsets) {
    self.topLabel = subviews.topLabel
    self.topRightLabel = subviews.topRightLabel
    self.middleLabel = subviews.middleLabel
    self.bottomLabel = subviews.bottomLabel
    
    self.spacing = spacing
    self.topRightLabelInsets = topRightLabelInsets
  }
  
  public static var empty = ThreeLinesLabelsGrid(
    subviews: .init(
      topLabel: UILabel(),
      topRightLabel: UILabel(),
      middleLabel: UILabel(),
      bottomLabel: UILabel()
    ),
    spacing: .zero,
    topRightLabelInsets: .zero
  )
  
  public func view() -> UIView {
    .vstack(
      spacing: spacing.vertical,
      [
        .hstack(
          alignment: .top,
          distribution: .fill,
          spacing: spacing.horizontal,
          [
            topLabel,
            topRightLabel
              .fitToContent(axis: [.horizontal])
              .withInsets(topRightLabelInsets)
          ]
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
