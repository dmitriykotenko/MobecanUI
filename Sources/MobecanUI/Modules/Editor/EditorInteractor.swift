// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift


public protocol EditorInteractorProtocol {
  
  associatedtype InputValue
  associatedtype OutputValue
  associatedtype SomeError: Error
  
  var initialValue: Observable<InputValue?> { get }
  var savingStatus: Observable<Loadable<OutputValue, SomeError>?> { get }
  
  var save: AnyObserver<OutputValue> { get }
  var resetSavingStatus: AnyObserver<Void> { get }
  var userWantsToCloseModule: AnyObserver<Void> { get }
}


open class EditorInteractor<InputValue, OutputValue, SomeError: Error>: EditorInteractorProtocol {
  
  @RxOutput(nil) open var initialValue: Observable<InputValue?>
  @RxOutput(nil) open var savingStatus: Observable<Loadable<OutputValue, SomeError>?>

  @RxInput open var save: AnyObserver<OutputValue>
  @RxInput open var resetSavingStatus: AnyObserver<Void>
  @RxInput open var userWantsToCloseModule: AnyObserver<Void>

  open var saver: Saver<OutputValue, SomeError>? = nil

  open private(set) lazy var close = _userWantsToCloseModule.asObservable()

  private var saving: LoadingOperation<OutputValue, OutputValue, SomeError>?
  
  private let disposeBag = DisposeBag()

  public init() {
    saving = .init(
      when: _save.asObservable(),
      load: { [weak self] in self?.saver?.save($0) ?? .never() },
      bindResultTo: _savingStatus.mapObserver { $0 }
    )

    disposeBag {
      _savingStatus <== _resetSavingStatus.map { nil }
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
