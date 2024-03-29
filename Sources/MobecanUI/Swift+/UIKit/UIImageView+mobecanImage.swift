// Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import RxCocoa
import RxSwift
import UIKit


public extension UIImageView {

  func setMobecanImage(_ image: Image?,
                       placeholder: UIImage? = nil,
                       hideIfNil: Bool = false) {
    switch image {
    case .image(let uiImage):
      self.image = uiImage
    case .tintedImage(let uiImage, let color):
      self.image = uiImage.withRenderingMode(.alwaysTemplate)
      self.tintColor = color
    case .url(let url):
      self.kf.setImage(with: url, placeholder: placeholder)
    case nil:
      self.image = nil
    }

    self.isHidden = hideIfNil && (image == nil)
  }
}


public extension Reactive where Base: UIImageView {

  func mobecanImage(placeholder: UIImage? = nil,
                    hideIfNil: Bool) -> Binder<Image?> {
    Binder(base) { view, image in
      view.setMobecanImage(
        image,
        placeholder: placeholder,
        hideIfNil: hideIfNil
      )
    }
  }
}
