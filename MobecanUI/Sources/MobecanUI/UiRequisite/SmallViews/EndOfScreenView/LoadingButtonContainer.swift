//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public protocol LoadingButtonContainer: UIView {

  var contentView: UIView { get }
  
  var hint: AnyObserver<String?> { get }
  var errorText: AnyObserver<String?> { get }
  var title: AnyObserver<String?> { get }
  
  var isLoading: AnyObserver<Bool> { get }
  var isEnabled: AnyObserver<Bool> { get }
  
  var height: Driver<CGFloat> { get }
  var buttonTap: Observable<Void> { get }
}
