//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol EditorInteractorProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error
  
  var initialValue: Observable<InputValue?> { get }
  var valueSaved: Observable<Result<OutputValue, SomeError>> { get }
  
  var save: AnyObserver<OutputValue> { get }
}


public class EditorInteractor<InputValue, OutputValue, SomeError: Error>: EditorInteractorProtocol {
  
  @RxOutput(nil) public var initialValue: Observable<InputValue?>
  @RxOutput public var valueSaved: Observable<Result<OutputValue, SomeError>>
  
  @RxInput public var save: AnyObserver<OutputValue>

  @RxInput(nil) var saver: AnyObserver<Saver<OutputValue, SomeError>?>
  
  private let disposeBag = DisposeBag()

  public init() {
    _save
      .withLatestFrom(_saver.filterNil()) { (value: $0, saver: $1) }
      .flatMap { $0.saver.save($0.value) }
      .bind(to: _valueSaved)
      .disposed(by: disposeBag)
  }
  
  func with(initialValue: Observable<InputValue?>) {
    initialValue
      .neverEnding()
      .bind(to: _initialValue)
      .disposed(by: disposeBag)    
  }
}
