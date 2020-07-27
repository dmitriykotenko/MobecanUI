//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public struct NavigationBarContent: Equatable, Hashable {
  
  public var title: StringOrView?
  public var subtitle: StringOrView?
  public var background: ColorImageOrView?
  public var rightView: UIView?

  public init(title: StringOrView? = nil,
              subtitle: StringOrView? = nil,
              background: ColorImageOrView? = nil,
              rightView: UIView? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.background = background
    self.rightView = rightView
  }
  
  public static let empty = NavigationBarContent()

  public static func title(_ title: StringOrView) -> NavigationBarContent {
    .init(title: title)
  }

  public static func background(_ background: ColorImageOrView) -> NavigationBarContent {
    .init(background: background)
  }
}
