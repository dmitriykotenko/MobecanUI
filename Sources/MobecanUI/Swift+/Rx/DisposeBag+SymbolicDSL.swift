//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public extension DisposeBag {

  func callAsFunction(@DisposablesResultBuilder disposables: () -> [Disposable]) {
    disposables().disposed(by: self)
  }
}


@resultBuilder
public class DisposablesResultBuilder {

  public static func buildBlock(_ components: Disposable...) -> [Disposable] {
    components
  }
}


infix operator ==> : DefaultPrecedence

public extension Observable {

  static func ==> <Input: ObserverType>(output: Observable<Element>, input: Input) -> Disposable
  where Input.Element == Element {
    output.bind(to: input)
  }

  static func ==> <Input: ObserverType>(output: Observable<Element>, input: (Input, DisposeBag))
  where Input.Element == Element {
    output.bind(to: input.0).disposed(by: input.1)
  }
}


public extension ObservableConvertibleType {

  static func ==> <Input: ObserverType>(output: Self, input: Input) -> Disposable
  where Input.Element == Element {
    output.asObservable().bind(to: input)
  }

  static func ==> <Input: ObserverType>(output: Self, input: (Input, DisposeBag))
  where Input.Element == Element {
    output.asObservable().bind(to: input.0).disposed(by: input.1)
  }
}


infix operator <== : DefaultPrecedence

public extension ObserverType {

  static func <== <Output: Observable<Element>>(input: Self, output: Output) -> Disposable {
    output.bind(to: input)
  }

  static func <== <Output: Observable<Element>>(input: Self, output: (Output, DisposeBag)) {
    output.0.bind(to: input).disposed(by: output.1)
  }

  static func <== <Output: ObservableType>(input: Self, output: Output) -> Disposable
  where Output.Element == Element {
    output.bind(to: input)
  }

  static func <== <Output: ObservableType>(input: Self, output: (Output, DisposeBag))
  where Output.Element == Element {
    output.0.bind(to: input).disposed(by: output.1)
  }
}
