//  Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import UIKit


public struct Tab: Equatable {
  
  public let title: String
  public let icon: UIImage
  public let viewController: UIViewController
  
  public init(title: String,
              icon: UIImage,
              viewController: UIViewController) {
    self.title = title
    self.icon = icon
    self.viewController = viewController
  }
  
  public static func == (this: Tab, that: Tab) -> Bool {
    return this.viewController == that.viewController
  }
}
