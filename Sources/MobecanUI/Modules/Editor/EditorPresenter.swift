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

  var intermediateValueProcessingStatus: Driver<Loadable<OutputValue, SomeError>?> { get }

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

  @RxDriverOutput(nil) open var intermediateValueProcessingStatus: Driver<Loadable<OutputValue, SomeError>?>

  @RxInput open var value: AnyObserver<SoftResult<OutputValue, SomeError>>
  @RxInput open var finalizeButtonTap: AnyObserver<Void>
  @RxInput open var resetFinalizationStatus: AnyObserver<Void>

  @RxInput open var closeButtonTap: AnyObserver<Void>

  private let errorFormatter: (SomeError) -> String?

  private let disposeBag = DisposeBag()

  public init(checker: Checker<InputValue, OutputValue, SomeError>,
              hintFormatter: HintFormatter = .alwaysNil(),
              errorFormatter: @escaping (SomeError) -> String?) {
    self.errorFormatter = errorFormatter

    disposeBag {
      _isFinalizeButtonEnabled <==
        .combineLatest(initialValue.asObservable(), _value) { checker.isOutputValueValid($0, $1) }

      _hint <== Driver
        .combineLatest(
          initialValue,
          _value.asDriver(onErrorDriveWith: .never()),
          doNotDisturbMode,
          intermediateValueProcessingStatus
        ) {
          hintFormatter.hint(
            HintFormatter.Input(
              initialValue: $0,
              editedValue: $1,
              doNotDisturbMode: $2,
              intermediateValueProcessingStatus: $3
            )
          )
        }

      _errorText <== error.map { $0.flatMap(errorFormatter) }

      _doNotDisturbMode <== _finalizeButtonTap.map { .off }
    }
  }

  public convenience init() {
    self.init(
      checker: .alwaysTrue(),
      hintFormatter: .alwaysNil(),
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
        // После того, как значение успешно финализировано, модуль должен немедленно закрыться,
        // поэтому не нужно отправлять `.success` во вью-контроллер.
        .filter { $0?.asSuccess == nil }
        .map { $0?.isLoading == true }

      _error <== .merge(
        interactor.finalizationStatus.map(\.?.asError),
        // Прячем сообщение об ошибке после того, как пользователь изменил value.
        _value.map { _ in nil }
      )

      _intermediateValueProcessingStatus <== interactor.intermediateValueProcessingStatus

      _value ==> interactor.userDidChangeValue

      _finalizeButtonTap
        .withLatestFrom(_value.compactMap(\.value))
        .filterWith(isFinalizeButtonEnabled)
        ==> interactor.finalize

      _resetFinalizationStatus ==> interactor.resetFinalizationStatus

      _closeButtonTap ==> interactor.userWantsToCloseModule
    }
  }
}
