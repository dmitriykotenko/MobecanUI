// Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import UIKit


public struct Tab: Equatable {
  
  public let title: String
  public let icon: UIImage
  public let badgeColor: Observable<UIColor?>
  public let viewController: UIViewController
  
  public init(title: String,
              icon: UIImage,
              badgeColor: Observable<UIColor?> = .just(nil),
              viewController: UIViewController) {
    self.title = title
    self.icon = icon
    self.badgeColor = badgeColor
    self.viewController = viewController
  }
  
  public static func == (this: Tab, that: Tab) -> Bool {
    this.viewController == that.viewController
  }
}
