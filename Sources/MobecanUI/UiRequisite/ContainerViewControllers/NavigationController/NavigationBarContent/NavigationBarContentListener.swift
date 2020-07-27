//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


class NavigationBarContentListener {
  
  private(set) lazy var content: Driver<NavigationBarContent> =
    Driver
      .zip(customContentProvider, titleListener)
      .flatMapLatest {
        $0?.navigationBarContent ?? $1.title.map { .plainTextTitle($0) }
      }
      .startWith(.empty)

  private lazy var titleListener =
    appearingViewController.map { ViewControllerTitleListener(viewController: $0) }
  
  private lazy var customContentProvider =
    appearingViewController.map { $0 as? NavigationBarContentProvider }
  
  private let appearingViewController: Driver<UIViewController>
  
  init(appearingViewController: Driver<UIViewController?>) {
    self.appearingViewController = appearingViewController.filterNil()
  }
}


private extension NavigationBarContent {
  
  static func plainTextTitle(_ stringOrNil: String?) -> NavigationBarContent {
    switch stringOrNil {
    case let string?:
      return .title(.string(string))
    case nil:
      return .empty
    }
  }
}
