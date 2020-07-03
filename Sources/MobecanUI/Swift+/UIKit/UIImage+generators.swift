//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIImage {
  
  static func from(view: UIView) -> UIImage {
    renderInCurrentContext(size: view.bounds.size) { context in
      view.layer.render(in: context)
    }
  }
  
  static func roundedRect(color: UIColor,
                          innerSize: CGSize,
                          cornerRadius: CGFloat,
                          insets: UIEdgeInsets = .zero) -> UIImage {
    let canvasRect = CGRect(
      origin: .zero,
      size: innerSize.insetBy(.init(amount: -cornerRadius)).insetBy(insets.negated)
    )
    
    let filledRect = canvasRect.inset(by: insets)
    
    return
      renderInCurrentContext(size: canvasRect.size) { context in
        context.setFillColor(color.cgColor)
        
        context.addPath(
          UIBezierPath(
            roundedRect: filledRect,
            cornerRadius: cornerRadius
          ).cgPath
        )
        
        context.fillPath()
      }
  }
  
  private static func renderInCurrentContext(size: CGSize,
                                             _ render: (CGContext) -> Void) -> UIImage {
    let scale = UIScreen.main.scale
    
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    
    UIGraphicsGetCurrentContext().map(render)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return UIImage(cgImage: image!.cgImage!, scale: scale, orientation: .up)
  }
}
