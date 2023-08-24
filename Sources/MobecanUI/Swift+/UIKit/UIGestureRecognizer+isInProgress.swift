// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxGesture
import RxSwift
import UIKit


public typealias Observable = RxSwift.Observable


public extension Observable where Element: UIGestureRecognizer {

  var isInProgress: Observable<Bool> {
    let began = when(.began).mapToVoid()
    
    let ended = Observable.merge(
      when(.ended),
      when(.failed),
      when(.cancelled),
      when(.recognized)
    ).mapToVoid()
    
    return Observable<Bool>
      .merge(began.mapToTrue(), ended.mapToFalse())
      .startWith(false)
      .distinctUntilChanged()
      .share(replay: 1, scope: .forever)
  }
}
