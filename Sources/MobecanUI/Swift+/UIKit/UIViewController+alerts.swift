//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIViewController {
  
  static func alert(title: String? = nil,
                    message: String? = nil,
                    actions: [AlertAction]) -> UIAlertController {
    alertController(
      title: title,
      message: message,
      style: .alert,
      actions: actions
    )
  }
  
  static func actionSheet(title: String? = nil,
                          message: String? = nil,
                          actions: [AlertAction]) -> UIAlertController {
    alertController(
      title: title,
      message: message,
      style: .actionSheet,
      actions: actions
    )
  }
  
  static func alertController(title: String? = nil,
                              message: String? = nil,
                              style: UIAlertController.Style,
                              actions: [AlertAction]) -> UIAlertController {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: style
    )
    
    actions.forEach {
      alertController.addAction(UIAlertAction(title: $0.title, style: $0.style, handler: $0.handler))
    }
    
    return alertController
  }
}


public extension UIViewController {
  
  struct AlertAction {
    
    public let style: UIAlertAction.Style
    public let title: String
    public let handler: ((UIAlertAction) -> Void)?
    
    public static func `default`(title: String,
                                 handler: ((UIAlertAction) -> Void)? = nil) -> AlertAction {
      AlertAction(
        style: .default,
        title: title,
        handler: handler
      )
    }
    
    public static func cancel(title: String,
                              handler: ((UIAlertAction) -> Void)? = nil) -> AlertAction {
      AlertAction(
        style: .cancel,
        title: title,
        handler: handler
      )
    }
    
    public static func destructive(title: String,
                                   handler: ((UIAlertAction) -> Void)? = nil) -> AlertAction {
      AlertAction(
        style: .destructive,
        title: title,
        handler: handler
      )
    }
  }
}
