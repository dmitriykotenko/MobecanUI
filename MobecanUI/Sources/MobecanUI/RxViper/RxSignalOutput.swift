//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


@propertyWrapper
public class RxSignalOutput<Element>: ObserverType {
  
  private let relay = PublishRelay<Element>()
  
  public init() {}
  
  public var wrappedValue: Signal<Element> {
    return relay.asSignal()
  }
  
  public func accept(_ event: Element) {
    onNext(event)
  }
  
  public func on(_ event: Event<Element>) {
    switch event {
    case .next(let element):
      relay.accept(element)
    case let .error(error):
      fatalError("Binding error to RxSignalOutput: \(error)")
    case .completed:
      break
    }
  }
}
