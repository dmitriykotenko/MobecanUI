// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


/// Listens events on main scheduler.
///
/// Accepts only .next events and throws exception on .error or .completed event.
@propertyWrapper
public class RxUiInput<Element>: ObservableType {
  
  private let publishRelay: PublishRelay<Element> = PublishRelay()
  private var behaviorRelay: BehaviorRelay<Element>?

  // Separate MainScheduler is needed,
  // because sometimes MainScheduler.instance does not execute subscriber callbacks immediately.
  private lazy var mainScheduler = MainScheduler()
  
  public init() {}
  
  public init(_ initialValue: Element) {
    behaviorRelay = BehaviorRelay(value: initialValue)
  }
  
  public var wrappedValue: AnyObserver<Element> {
    AnyObserver { [weak self] in
      switch $0 {
      case .next(let element):
        self?.behaviorRelay?.accept(element) ?? self?.publishRelay.accept(element)
      case .error, .completed:
        // Do nothing. RxUiInput can not finish or produce error.
        break
      }
    }
  }
  
  public func subscribe<Observer>(_ observer: Observer) -> Disposable
  where Observer: ObserverType, Element == Observer.Element {

    behaviorRelay?.observe(on: mainScheduler).subscribe(observer)
    ?? publishRelay.observe(on: mainScheduler).subscribe(observer)
  }
}
