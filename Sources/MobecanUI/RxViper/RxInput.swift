// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


@propertyWrapper
public class RxInput<Element>: ObservableType {
  
  private let publishSubject: PublishSubject<Element> = PublishSubject()
  private var behaviorSubject: BehaviorSubject<Element>?
  
  public init() {}
  
  public init(_ initialValue: Element) {
    behaviorSubject = BehaviorSubject(value: initialValue)
  }
  
  public var wrappedValue: AnyObserver<Element> {
    behaviorSubject?.asObserver() ?? publishSubject.asObserver()
  }
  
  public func subscribe<Observer>(_ observer: Observer) -> Disposable
    where Observer: ObserverType, Element == Observer.Element {
      
      behaviorSubject?.subscribe(observer) ?? publishSubject.subscribe(observer)
  }
}
