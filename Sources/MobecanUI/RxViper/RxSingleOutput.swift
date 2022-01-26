// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


@propertyWrapper
public class RxSingleOutput<Element>: ObserverType {
  
  private let subject = AsyncSubject<Element>()
  
  public init() {}
  
  public var wrappedValue: Single<Element> {
    subject.asSingle()
  }
  
  public func onSuccess(_ element: Element) {
    subject.onNext(element)
    subject.onCompleted()
  }
  
  public func on(_ event: Event<Element>) {
    subject.on(event)
  }
}
