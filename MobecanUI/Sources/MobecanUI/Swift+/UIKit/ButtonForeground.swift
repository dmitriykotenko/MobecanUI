//  Copyright © 2019 Mobecan. All rights reserved.

import UIKit


public struct ButtonForeground {
  
  public let title: String?
  public let image: UIImage?
  
  public init(title: String?,
              image: UIImage?) {
    self.title = title
    self.image = image
  }
  
  public static func title(_ title: String?) -> ButtonForeground {
    return ButtonForeground(
      title: title,
      image: nil
    )
  }
  
  public static func image(_ image: UIImage?) -> ButtonForeground {
    return ButtonForeground(
      title: nil,
      image: image
    )
  }
}


public extension UIButton {

  func foreground(for state: UIControl.State) -> ButtonForeground {
    return ButtonForeground(
      title: title(for: state),
      image: image(for: state)
    )
  }
  
  func setForeground(_ foreground: ButtonForeground,
                     for state: UIControl.State) {
    setTitle(foreground.title, for: state)
    setImage(foreground.image, for: state)
  }

}
