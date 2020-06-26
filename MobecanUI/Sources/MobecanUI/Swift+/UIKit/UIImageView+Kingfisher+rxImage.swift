//  Copyright © 2020 Mobecan. All rights reserved.

import Kingfisher
import RxCocoa
import RxSwift
import UIKit


public extension KingfisherWrapper where Base: UIImageView {

  func rxImage(placeholder: Kingfisher.Placeholder? = nil) -> Binder<Kingfisher.Resource?> {
    return Binder(base) { imageView, resource in
      imageView.kf.setImage(
        with: resource,
        placeholder: placeholder
      )
    }
  }
}
