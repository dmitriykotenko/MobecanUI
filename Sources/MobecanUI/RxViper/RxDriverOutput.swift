//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


@propertyWrapper
public class RxDriverOutput<Element>: ObserverType {
  
  private let relay: BehaviorRelay<Element>
  
  public init(_ initialValue: Element) {
    relay = BehaviorRelay(value: initialValue)
  }
  
  public var wrappedValue: Driver<Element> {
    relay.asDriver()
  }
  
  public func accept(_ event: Element) {
    onNext(event)
  }
  
  public func on(_ event: Event<Element>) {
    switch event {
    case .next(let element):
      relay.accept(element)
    case let .error(error):
      fatalError("Binding error to RxDriverOutput: \(error)")
    case .completed:
      break
    }
  }
}
