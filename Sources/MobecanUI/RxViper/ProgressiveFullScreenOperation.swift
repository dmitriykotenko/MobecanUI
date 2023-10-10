// Copyright © 2023 Mobecan. All rights reserved.

import RxSwift
import UIKit


/// Асинхронная операция, которой для взаимодействия с пользователем нужен отдельный экран,
/// умеющий отдавать промежуточные значения.
open class ProgressiveFullScreenOperation<Input, Output> {

  private let when: Observable<Input>

  private let disposeBag = DisposeBag()

  public init(when: Observable<Input>,
              show initModule: @escaping (Input) -> ModuleDependency.Output<Output>,
              via demonstrator: @escaping () -> Demonstrator?,
              animating: Bool? = nil,
              bindResultTo resultObserver: AnyObserver<Output> = .empty) {
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
