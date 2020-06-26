//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


@propertyWrapper
public class RxSingleOutput<Element>: ObserverType {
  
  private let subject = AsyncSubject<Element>()
  
  public init() {}
  
  public var wrappedValue: Single<Element> {
    return subject.asSingle()
  }
  
  public func onSuccess(_ element: Element) {
    subject.onNext(element)
    subject.onCompleted()
  }
  
  public func on(_ event: Event<Element>) {
    switch event {
    case .next(let element):
      subject.onNext(element)
    case let .error(error):
      fatalError("Binding error to RxSingleOutput: \(error)")
    case .completed:
      subject.onCompleted()
    }
  }
}
