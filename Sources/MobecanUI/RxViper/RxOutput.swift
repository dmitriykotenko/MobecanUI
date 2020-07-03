//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


@propertyWrapper
public class RxOutput<Element>: ObserverType {
  
  private let publishRelay: PublishRelay<Element> = PublishRelay()
  private var behaviorRelay: BehaviorRelay<Element>?
  
  public init() {}
  
  public init(_ initialValue: Element) {
    behaviorRelay = BehaviorRelay(value: initialValue)
  }
  
  public var wrappedValue: Observable<Element> {
    behaviorRelay?.asObservable() ?? publishRelay.asObservable()
  }
  
  public func accept(_ event: Element) {
    onNext(event)
  }
  
  public func on(_ event: Event<Element>) {
    switch event {
    case .next(let element):
      behaviorRelay?.accept(element) ?? publishRelay.accept(element)
    case let .error(error):
      fatalError("Binding error to RxOutput: \(error)")
    case .completed:
      fatalError("Binding .completed to RxOutput.")
    }
  }
}
