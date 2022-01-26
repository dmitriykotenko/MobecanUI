// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


// Listen for changes of frames, bounds and centers of given views.
public class FramesListener {
  
  @RxOutput(()) public var framesChanged: Observable<Void>
  
  private var frameListeners: [NSKeyValueObservation] = []
  private var boundsListeners: [NSKeyValueObservation] = []
  private var centerListeners: [NSKeyValueObservation] = []
  
  private let disposeBag = DisposeBag()
  
  public init(views: [UIView]) {
    let relay = PublishRelay<Void>()
    
    frameListeners = views
      .map { $0.observe(\.frame) { _, _ in relay.accept(()) } }
    
    boundsListeners = views
      .map { $0.observe(\.bounds) { _, _ in relay.accept(()) } }
        
    centerListeners = views
      .map { $0.observe(\.center) { _, _ in relay.accept(()) } }

    relay.bind(to: _framesChanged).disposed(by: disposeBag)
  }
}
