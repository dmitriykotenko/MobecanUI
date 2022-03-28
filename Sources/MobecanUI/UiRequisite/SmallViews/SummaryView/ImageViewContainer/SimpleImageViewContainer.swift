// Copyright © 2020 Mobecan. All rights reserved.

import UIKit
import LayoutKit


public extension ImageViewContainer {
  
  static func simple(imageView: UIImageView,
                     placeholder: UIImage? = nil,
                     hideIfImageIsNil: Bool = false,
                     placement: SimpleImageViewContainer.VerticalPlacement) -> ImageViewContainer {
    SimpleImageViewContainer(
      imageView: imageView,
      placeholder: placeholder,
      hideIfImageIsNil: hideIfImageIsNil,
      verticalPlacement: placement
    )
  }
}


open class SimpleImageViewContainer: ImageViewContainer {
  
  public enum VerticalPlacement {
    case center
    case top(CGFloat)
    case bottom(CGFloat)
  }
  
  public let placeholder: UIImage?
  public let hideIfImageIsNil: Bool
  public let verticalPlacement: VerticalPlacement
  
  public init(imageView: UIImageView,
              placeholder: UIImage? = nil,
              hideIfImageIsNil: Bool,
              verticalPlacement: VerticalPlacement) {
    self.placeholder = placeholder
    self.hideIfImageIsNil = hideIfImageIsNil
    self.verticalPlacement = verticalPlacement
    
    super.init(
      imageView: imageView,
      containerView: SimpleImageViewContainer.containerView(
        imageView,
        verticalPlacement: verticalPlacement
      )
    )
  }
  
  private static func containerView(_ imageView: UIImageView,
                                    verticalPlacement: VerticalPlacement) -> UIView {
    switch verticalPlacement {
    case .top(let inset):
      return imageView.insideAutohidingContainer(alignment: .topFill, insets: .top(inset))
    case .bottom(let inset):
      return imageView.insideAutohidingContainer(alignment: .bottomFill, insets: .bottom(inset))
    case .center:
      return imageView.insideAutohidingContainer(alignment: .centerFill, insets: .zero)
    }
  }
  
  override open func display(image: Image?) {
    imageView.isHidden = (image == nil && hideIfImageIsNil)

    switch image {
    case .image(let image):
      imageView.image = image
    case .tintedImage(let image, let color):
      imageView.templateImage = image
      imageView.tintColor = color
    case .url(let url):
      imageView.kf.setImage(with: url, placeholder: placeholder)
    case nil:
      imageView.image = placeholder
    }
  }
}


private extension UIView {

  func insideAutohidingContainer(alignment: LayoutKit.Alignment,
                                 insets: UIEdgeInsets) -> UIView {
    AutohidingContainerView(
      self,
      layout: {
        LayoutableView(
          layout: $0.withAlignment(alignment).withInsets(insets)
        )
      }
    )
  }
}
