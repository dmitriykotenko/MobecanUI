// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol EditorInteractorProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error
  
  var initialValue: Observable<InputValue?> { get }
  var finalizationStatus: Observable<Loadable<OutputValue, SomeError>?> { get }
  
  var userDidChangeValue: AnyObserver<OutputValue> { get }

  var finalize: AnyObserver<OutputValue> { get }
  var resetFinalizationStatus: AnyObserver<Void> { get }
  var userWantsToCloseModule: AnyObserver<Void> { get }
}


open class EditorInteractor<InputValue, OutputValue, SomeError: Error>: EditorInteractorProtocol {
  
  @RxOutput(nil) open var initialValue: Observable<InputValue?>
  @RxOutput(nil) open var finalizationStatus: Observable<Loadable<OutputValue, SomeError>?>

  @RxInput open var userDidChangeValue: AnyObserver<OutputValue>

  @RxInput open var finalize: AnyObserver<OutputValue>
  @RxInput open var resetFinalizationStatus: AnyObserver<Void>
  @RxInput open var userWantsToCloseModule: AnyObserver<Void>

  open var finalizer: AsyncProcessor<OutputValue, SomeError>? = nil
  open var intermediateValueProcessor: AsyncProcessor<OutputValue, SomeError>? = nil

  open private(set) lazy var close = _userWantsToCloseModule.asObservable()

  private var finalizing: LoadingOperation<OutputValue, OutputValue, SomeError>?
  private var intermediateValueProcessing: LoadingOperation<OutputValue, OutputValue, SomeError>?

  private let disposeBag = DisposeBag()

  public init() {
    finalizing = .init(
      when: _finalize.asObservable(),
      load: { [weak self] in self?.finalizer?.process($0) ?? .never() },
      bindResultTo: _finalizationStatus.mapObserver { $0 }
    )

    intermediateValueProcessing = .init(
      when: _userDidChangeValue.asObservable(),
      load: { [weak self] in self?.intermediateValueProcessor?.process($0) ?? .never() },
      bindNotNilResultTo: .empty
    )

    disposeBag {
      _finalizationStatus <== _resetFinalizationStatus.map { nil }
    }
  }
  
  @discardableResult
  func with(initialValue: Observable<InputValue?>) -> Self {
    disposeBag {
      initialValue ==> _initialValue
    }
    return self
  }
}
