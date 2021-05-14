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

  /// Why pinnedTo: parameter is needed?
  ///
  /// On iPad, we must specify pin rectangle for action sheets —
  /// otherwise, the application crashes when presenting the alert:
  /// https://stackoverflow.com/questions/31577140/uialertcontroller-is-crashed-ipad
  ///
  /// On iPhone, pinning is unnecessary and has no effect.
  static func actionSheet(title: String? = nil,
                          message: String? = nil,
                          actions: [AlertAction],
                          pinnedTo view: UIView? = nil) -> UIAlertController {
    alertController(
      title: title,
      message: message,
      style: .actionSheet,
      actions: actions,
      pinnedTo: view
    )
  }
  
  static func alertController(title: String? = nil,
                              message: String? = nil,
                              style: UIAlertController.Style,
                              actions: [AlertAction],
                              pinnedTo view: UIView? = nil) -> UIAlertController {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: style
    )
    
    actions.forEach {
      alertController.addAction(UIAlertAction(title: $0.title, style: $0.style, handler: $0.handler))
    }

    alertController.pin(to: view ?? defaultPinView)

    return alertController
  }

  private static var defaultPinView: UIView? {
    UIApplication.shared.windows.first?.rootViewController?.view
  }
}


public extension UIViewController {
  
  struct AlertAction {
    
    public let style: UIAlertAction.Style
    public let title: String
    public let handler: ((UIAlertAction) -> Void)?

    public init(style: UIAlertAction.Style,
                title: String,
                handler: ((UIAlertAction) -> Void)? = nil) {
      self.style = style
      self.title = title
      self.handler = handler
    }
    
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
