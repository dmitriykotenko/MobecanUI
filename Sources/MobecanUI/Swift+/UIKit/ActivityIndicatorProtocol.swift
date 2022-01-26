// Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol ActivityIndicatorProtocol: UIView {

  var color: UIColor! { get set }
  var isAnimating: Bool { get }

  func startAnimating()
  func stopAnimating()
}


extension ActivityIndicatorProtocol {

  public var rxIsAnimating: Binder<Bool> {
    Binder(self) { activityIndicator, active in
      if active {
        activityIndicator.startAnimating()
      } else {
        activityIndicator.stopAnimating()
      }
    }
  }
}
