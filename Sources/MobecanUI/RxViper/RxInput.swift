// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


@propertyWrapper
public class RxInput<Element>: ObservableType {
  
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
      case .error, .completed:
        // Ничего не делаем. RxInput игнорирует сигналы о завершении или об ошибке.
        break
      }
    }
  }

  public func subscribe<Observer>(_ observer: Observer) -> Disposable
  where Observer: ObserverType, Element == Observer.Element {
      
    behaviorRelay?.subscribe(observer) ?? publishRelay.subscribe(observer)
  }
}
