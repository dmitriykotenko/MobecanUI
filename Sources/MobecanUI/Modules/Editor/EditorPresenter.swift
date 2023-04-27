// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


public protocol EditorPresenterProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error

  var initialValue: Driver<InputValue?> { get }
  var isFinalizeButtonEnabled: Driver<Bool> { get }
  var isFinalizing: Driver<Bool> { get }

  var doNotDisturbMode: Driver<DoNotDisturbMode> { get }
  var hint: Driver<String?> { get }
  var errorText: Driver<String?> { get }

  var value: AnyObserver<SoftResult<OutputValue, SomeError>> { get }
  var finalizeButtonTap: AnyObserver<Void> { get }
  var resetFinalizationStatus: AnyObserver<Void> { get }

  var closeButtonTap: AnyObserver<Void> { get }
}


public class EditorPresenter<InputValue, OutputValue, SomeError: Error>: EditorPresenterProtocol {

  @RxDriverOutput(nil) open var initialValue: Driver<InputValue?>

  @RxDriverOutput(true) open var isFinalizeButtonEnabled: Driver<Bool>
  @RxDriverOutput(false) open var isFinalizing: Driver<Bool>

  @RxDriverOutput(.on) open var doNotDisturbMode: Driver<DoNotDisturbMode>
  @RxDriverOutput(nil) open var hint: Driver<String?>
  @RxDriverOutput(nil) open var errorText: Driver<String?>

  @RxOutput(nil) private var error: Observable<SomeError?>

  @RxInput open var value: AnyObserver<SoftResult<OutputValue, SomeError>>
  @RxInput open var finalizeButtonTap: AnyObserver<Void>
  @RxInput open var resetFinalizationStatus: AnyObserver<Void>

  @RxInput open var closeButtonTap: AnyObserver<Void>

  private let errorFormatter: (SomeError) -> String?

  private let disposeBag = DisposeBag()
  
  public init(checker: Checker<InputValue, OutputValue, SomeError>,
              hintFormatter: @escaping (SoftResult<OutputValue, SomeError>) -> String? = { _ in nil },
              errorFormatter: @escaping (SomeError) -> String?) {
    self.errorFormatter = errorFormatter

    disposeBag {
      _isFinalizeButtonEnabled <==
        .combineLatest(initialValue.asObservable(), _value) { checker.isOutputValueValid($0, $1) }

      _hint <== _value.map { hintFormatter($0) }
      _errorText <== error.map { $0.flatMap(errorFormatter) }
      _doNotDisturbMode <== _finalizeButtonTap.map { .off }
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

    disposeBag {
      _initialValue <== interactor.initialValue

      _isFinalizing <== interactor.finalizationStatus
        // After value is successfully finalized, the module must be immediately closed,
        // so we don't need to send `.success` to view controller.
        .filter { $0?.asSuccess == nil }
        .map { $0?.isLoading == true }

      _error <== .merge(
        interactor.finalizationStatus.map(\.?.asError),
        // Hide error message after value has been changed by user.
        valueDidChange().map { nil }
      )

      _value ==> interactor.userDidChangeValue

      _finalizeButtonTap
        .withLatestFrom(_value)
        .compactMap { $0.isSuccess ? $0.value : nil }
        .filterWith(isFinalizeButtonEnabled)
        ==> interactor.finalize

      _resetFinalizationStatus ==> interactor.resetFinalizationStatus

      _closeButtonTap ==> interactor.userWantsToCloseModule
    }
  }

  private func valueDidChange() -> Observable<Void> {
    _value.skip(1).take(1).mapToVoid()
  }
}
