// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public protocol EditorPresenterProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error

  var initialValue: Driver<InputValue?> { get }
  var isSaveButtonEnabled: Driver<Bool> { get }
  var isSaving: Driver<Bool> { get }

  var doNotDisturbMode: Driver<DoNotDisturbMode> { get }
  var hint: Driver<String?> { get }
  var errorText: Driver<String?> { get }

  var value: AnyObserver<Result<OutputValue, SomeError>> { get }
  var saveButtonTap: AnyObserver<Void> { get }
}


public class EditorPresenter<InputValue, OutputValue, SomeError: Error>: EditorPresenterProtocol {

  @RxDriverOutput(nil) public var initialValue: Driver<InputValue?>

  @RxDriverOutput(true) public var isSaveButtonEnabled: Driver<Bool>
  @RxDriverOutput(false) public var isSaving: Driver<Bool>

  @RxDriverOutput(.on) public var doNotDisturbMode: Driver<DoNotDisturbMode>
  @RxDriverOutput(nil) public var hint: Driver<String?>
  @RxDriverOutput(nil) public var errorText: Driver<String?>

  @RxOutput(nil) private var error: Observable<SomeError?>

  @RxInput public var value: AnyObserver<Result<OutputValue, SomeError>>
  @RxInput public var saveButtonTap: AnyObserver<Void>

  private let errorFormatter: (SomeError) -> String?

  private let disposeBag = DisposeBag()
  
  public init(checker: Checker<InputValue, OutputValue, SomeError>,
              hintFormatter: @escaping (Result<OutputValue, SomeError>) -> String? = { _ in nil },
              errorFormatter: @escaping (SomeError) -> String?) {
    self.errorFormatter = errorFormatter

    disposeBag {
      _isSaveButtonEnabled <==
        .combineLatest(initialValue.asObservable(), _value) { checker.isOutputValueValid($0, $1) }

      _hint <== _value.map { hintFormatter($0) }
      _errorText <== error.map { $0.flatMap(errorFormatter) }
      _doNotDisturbMode <== _saveButtonTap.map { .off }
    }
  }
  
  public convenience init() {
    self.init(
      checker: .alwaysTrue(),
      hintFormatter: { _ in nil },
      errorFormatter: { "\($0.localizedDescription)" }
    )
  }

  open func setInteractor<Interactor: EditorInteractorProtocol>(_ interactor: Interactor)
  where
  Interactor.InputValue == InputValue,
  Interactor.OutputValue == OutputValue,
  Interactor.SomeError == SomeError {

    let validValue = _value.asObservable().filterSuccess()

    let save = _saveButtonTap
      .filterWith(_value.map { $0.isSuccess })
      .withLatestFrom(validValue)
      .share(replay: 1, scope: .forever)

    let savingFailed = interactor.valueSaved.filterFailure().share()

    disposeBag {
      interactor.initialValue ==> _initialValue

      save ==> interactor.save

      _isSaving <== .merge(
        save.map { _ in true },
        // After value is successfully saved, the module must be immediately closed,
        // so we don't need to send `.success` to view controller.
        savingFailed.map { _ in false }
      )

      _error <== savingFailed.flatMap { [weak self] savingError in
        Observable.concat(
          .just(savingError),
          // Hide error message after value has been changed by user.
          (self?.valueDidChange() ?? .never()).map { nil }
          // FIXME: should we use .doNotDisturbMode instead of resetting error?
        )
      }
    }
  }

  private func valueDidChange() -> Observable<Void> {
    _value.skip(1).take(1).mapToVoid()
  }
}
