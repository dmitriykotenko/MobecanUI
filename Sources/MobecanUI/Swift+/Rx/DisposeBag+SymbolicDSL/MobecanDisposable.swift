// Copyright © 2026 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime


public struct MobecanDisposable {

  public var build: (SchedulerType?) -> Disposable?

  public init(build: @escaping (SchedulerType?) -> Disposable?) {
    self.build = build
  }

  public init(_ disposable: Disposable) {
    self.init { _ in disposable }
  }

  public init<Producer: ObservableConvertibleType, Listener: ObserverType>(
    signal: Producer?,
    listener: Listener
  ) where Listener.Element == Producer.Element {
    self.init { scheduler in
      if let scheduler {
        signal?.asObservable().observe(on: scheduler).bind(to: listener)
      } else {
        signal?.asObservable().bind(to: listener)
      }
    }
  }

  public init<Producer: ObservableConvertibleType, Listener: ObserverType>(
    optionalSignal: Producer?,
    listener: Listener
  ) where Listener.Element == Producer.Element? {
    self.init { scheduler in
      if let scheduler {
        optionalSignal?.asObservable().observe(on: scheduler).bind(to: listener)
      } else {
        optionalSignal?.asObservable().bind(to: listener)
      }
    }
  }

  public init<Element, Listener: ObserverType>(
    optionalSignal: Observable<Element>?,
    listener: Listener
  ) where Listener.Element == Element? {
    self.init { scheduler in
      if let scheduler {
        optionalSignal?.observe(on: scheduler).bind(to: listener)
      } else {
        optionalSignal?.bind(to: listener)
      }
    }
  }

  public init<Producer: ObservableConvertibleType>(
    signal: Producer?,
    handler: @escaping (Producer.Element) -> Void
  ) {
    self.init { scheduler in
      if let scheduler {
        signal?.asObservable().observe(on: scheduler).subscribe(onNext: handler)
      } else {
        signal?.asObservable().subscribe(onNext: handler)
      }
    }
  }

  public init<Producer: ObservableConvertibleType>(
    signal: Producer?,
    handler: @escaping () -> Void
  ) where Producer.Element == Void {
    self.init { scheduler in
      if let scheduler {
        signal?.asObservable().observe(on: scheduler).subscribe(onNext: handler)
      } else {
        signal?.asObservable().subscribe(onNext: handler)
      }
    }
  }
}
