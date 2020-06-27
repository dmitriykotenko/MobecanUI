//  Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxSwift
import UIKit


public protocol TypedButton: UIView {
  
  associatedtype Value
  associatedtype Action
  
  var value: AnyObserver<Value?> { get }
  var tap: Observable<Action> { get }
}


extension UIButton: TypedButton {
  
  public typealias Value = ButtonForeground
  public typealias Action = Void
  
  public var value: AnyObserver<ButtonForeground?> {
    .onNext { [weak self] in
      $0.map { self?.rx.foreground().onNext($0) }
    }
  }
  
  public var tap: Observable<Void> { rx.tap.asObservable() }
}
