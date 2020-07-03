//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


/// Listens events on main scheduler.
///
/// Accepts only .next events and throws exception on .error or .completed event.
@propertyWrapper
public class RxUiInput<Element>: ObservableType {
  
  private let publishRelay: PublishRelay<Element> = PublishRelay()
  private var behaviorRelay: BehaviorRelay<Element>?
  
  public init() {}
  
  public init(_ initialValue: Element) {
    behaviorRelay = BehaviorRelay(value: initialValue)
  }
  
  public var wrappedValue: AnyObserver<Element> {
    AnyObserver { [weak self] in
      switch $0 {
      case .next(let element):
        self?.behaviorRelay?.accept(element) ?? self?.publishRelay.accept(element)
      case let .error(error):
        fatalError("Binding error to RxDriverOutput: \(error)")
      case .completed:
        break
      }
    }
  }
  
  public func subscribe<Observer>(_ observer: Observer) -> Disposable
    where Observer: ObserverType, Element == Observer.Element {
    behaviorRelay?.observeOn(MainScheduler.instance).subscribe(observer)
      ?? publishRelay.observeOn(MainScheduler.instance).subscribe(observer)
  }
}
