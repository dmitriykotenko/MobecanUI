// Copyright © 2020 Mobecan. All rights reserved.

import MobecanUI
import RxCocoa
import RxSwift
import UIKit


public class LoadingOperation<Query, Value, SomeError: Error> {

  @RxOutput(nil) public var state: Observable<Loadable<Value, SomeError>?>

  private let when: Observable<Query>

  private let disposeBag = DisposeBag()

  public init(when: Observable<Query>,
              load: @escaping (Query) -> Single<Result<Value, SomeError>>,
              bindResultTo resultObserver: AnyObserver<Loadable<Value, SomeError>>) {

    self.when = when

    disposeBag {
      when.flatMapLatest { Loading(query: $0, load: load) } ==> _state

      state.filterNil() ==> resultObserver
    }
  }
}
