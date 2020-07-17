//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public protocol EditorPresenterProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error

  var initialValue: Driver<InputValue?> { get }
  var isSaveButtonEnabled: Driver<Bool> { get }
  var isSaving: Driver<Bool> { get }
  var errorText: Driver<String?> { get }
  
  var value: AnyObserver<Result<OutputValue, SomeError>> { get }
  var saveButtonTap: AnyObserver<Void> { get }
}


public class EditorPresenter<InputValue, OutputValue, SomeError: Error>: EditorPresenterProtocol {

  @RxDriverOutput(nil) public var initialValue: Driver<InputValue?>
  @RxDriverOutput(true) public var isSaveButtonEnabled: Driver<Bool>
  @RxDriverOutput(false) public var isSaving: Driver<Bool>
  @RxDriverOutput(nil) public var errorText: Driver<String?>
  
  @RxInput public var value: AnyObserver<Result<OutputValue, SomeError>>
  @RxInput public var saveButtonTap: AnyObserver<Void>

  private let errorFormatter: (SomeError) -> String?
  
  private let disposeBag = DisposeBag()
  
  public init(checker: Checker<InputValue, OutputValue, SomeError>,
              errorFormatter: @escaping (SomeError) -> String?) {
    self.errorFormatter = errorFormatter
    
    Observable
      .combineLatest(initialValue.asObservable(), _value) { checker.isOutputValueValid($0, $1) }
      .bind(to: _isSaveButtonEnabled)
      .disposed(by: disposeBag)
  }
  
  public convenience init() {
    self.init(
      checker: .alwaysTrue(),
      errorFormatter: { "\($0.localizedDescription)" }
    )
  }

  open func setInteractor<Interactor: EditorInteractorProtocol>(_ interactor: Interactor)
    where
    Interactor.InputValue == InputValue,
    Interactor.OutputValue == OutputValue,
    Interactor.SomeError == SomeError {
    
      interactor.initialValue
        .bind(to: _initialValue)
        .disposed(by: disposeBag)
      
      let validValue = _value.asObservable().filterSuccess()
      
      let save = _saveButtonTap.withLatestFrom(validValue).share(replay: 1, scope: .forever)
      
      save.bind(to: interactor.save).disposed(by: disposeBag)
      
      save.map { _ in true }.bind(to: _isSaving).disposed(by: disposeBag)
      
      let savingFailed = interactor.valueSaved.filterFailure().share()
      
      // After value is successfully saved, the module must be immediately closed,
      // so we don't need to send `.success` to view controller.
      savingFailed
        .map { _ in false }
        .bind(to: _isSaving).disposed(by: disposeBag)
      
      savingFailed
        .flatMap { [weak self] error -> Observable<SomeError?> in
          Observable.concat(
            .just(error),
            // Hide error message after value has been changed by user.
            self?._value.skip(1).take(1).map { _ in nil } ?? .never()
            // FIXME: should we use .doNotDisturbMode instead of resetting error?
          )
        }
        .map { [errorFormatter] error in error.flatMap(errorFormatter) }
        .bind(to: _errorText)
        .disposed(by: disposeBag)
  }
}
