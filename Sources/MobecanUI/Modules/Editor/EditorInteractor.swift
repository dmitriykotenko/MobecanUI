// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol EditorInteractorProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error
  
  var initialValue: Observable<InputValue?> { get }
  var finalizationStatus: Observable<Loadable<OutputValue, SomeError>?> { get }
  
  var userDidChangeValue: AnyObserver<SoftResult<OutputValue, SomeError>> { get }

  var finalize: AnyObserver<OutputValue> { get }
  var resetFinalizationStatus: AnyObserver<Void> { get }
  var userWantsToCloseModule: AnyObserver<Void> { get }
}


open class EditorInteractor<InputValue, OutputValue, SomeError: Error>: EditorInteractorProtocol {
  
  @RxOutput(nil) open var initialValue: Observable<InputValue?>
  @RxOutput(nil) open var finalizationStatus: Observable<Loadable<OutputValue, SomeError>?>

  @RxInput open var userDidChangeValue: AnyObserver<SoftResult<OutputValue, SomeError>>

  @RxInput open var finalize: AnyObserver<OutputValue>
  @RxInput open var resetFinalizationStatus: AnyObserver<Void>
  @RxInput open var userWantsToCloseModule: AnyObserver<Void>

  /// Правила обработки финального значения.
  open var finalizer: AsyncProcessor<OutputValue, SomeError>? = nil

  /// Правила обработки промежуточного значения.
  open var intermediateValueProcessingPolicy: IntermediateValueProcessingPolicy<OutputValue, SomeError>? {
    didSet { setupIntermediateValueProcessing() }
  }

  open private(set) lazy var close = _userWantsToCloseModule.asObservable()

  private var finalizing:
    LoadingOperation<OutputValue, OutputValue, SomeError>?

  private var intermediateValueProcessing:
    LoadingOperation<SoftResult<OutputValue, SomeError>, OutputValue, SomeError>?

  private let disposeBag = DisposeBag()

  public init() {
    finalizing = .init(
      when: _finalize.asObservable(),
      load: { [weak self] in self?.finalizer?.process($0) ?? .never() },
      bindResultTo: _finalizationStatus.mapObserver { $0 }
    )

    disposeBag {
      _finalizationStatus <== _resetFinalizationStatus.map { nil }
    }
  }

  private func setupIntermediateValueProcessing() {
    guard let policy = intermediateValueProcessingPolicy else { return }

    intermediateValueProcessing = .init(
      when: _userDidChangeValue.throttle(policy.throttlingDuration, scheduler: MainScheduler.instance),
      load: { policy.processValue($0) ?? .never() },
      bindResultTo: .empty
    )
  }
  
  @discardableResult
  func with(initialValue: Observable<InputValue?>) -> Self {
    disposeBag {
      initialValue ==> _initialValue
    }
    return self
  }
}
