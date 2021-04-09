//  Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public extension UIImage {

  static func singlePixel(color: UIColor) -> UIImage {
    singleColorImage(color, size: .init(width: 1, height: 1))
  }

  static func singleColorImage(_ color: UIColor,
                               size: CGSize) -> UIImage {
    let canvasRect = CGRect(
      origin: .zero,
      size: size
    )

    return
      renderInCurrentContext(size: canvasRect.size, scale: 1) { context in
        context.setFillColor(color.cgColor)
        context.fill(canvasRect)
        context.fillPath()
    }
  }

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
                                             scale: CGFloat = UIScreen.main.scale,
                                             _ render: (CGContext) -> Void) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    
    UIGraphicsGetCurrentContext().map(render)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return UIImage(cgImage: image!.cgImage!, scale: scale, orientation: .up)
  }
}
