// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


/// Asynchronous operation which requires a separate screen to interact with the user
/// (e. g. editing of geographical address).
open class FullScreenOperation<Input, Output> {
  
  private let when: Observable<Input>
  
  private let disposeBag = DisposeBag()

  public init(when: Observable<Input>,
              show initModule: @escaping (Input) -> ModuleDependency.OneTime<Output>,
              via demonstrator: @escaping () -> Demonstrator?,
              animating: Bool? = nil,
              bindResultTo resultObserver: AnyObserver<Output>) {
    
    self.when = when
    
    let moduleAndOutput =
      when.observe(on: MainScheduler.instance).map { initModule($0) }.share()

    disposeBag {
      moduleAndOutput.flatMap(\.output) ==> resultObserver

      moduleAndOutput
        .flatMapLatest {
          demonstrator()?.demonstrate(module: $0.module, animating: animating)
          ?? .just(())
        }
        .subscribe()
    }
  }
}
