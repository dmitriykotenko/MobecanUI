// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class EditorViewController<InputValue, OutputValue, SomeError: Error>: UIViewController {

  open var buttonTitle: AnyObserver<String?> { finalizeButtonContainer.title }
  
  @RxUiInput(false) open var isFinalizing: AnyObserver<Bool>
  open var finalizeButtonTap: Observable<Void> { finalizeButtonContainer.buttonTap }

  @RxUiInput({ .just(.success($0)) }) open var externalValidator: AnyObserver<AsyncValidator<OutputValue, SomeError>>

  open var externalError: Driver<SomeError?> {
    Observable
      .combineLatest(valueGetter, _externalValidator)
      .flatMap { $0.externalError(from: $1) }
      .asDriver(onErrorDriveWith: .never())
  }
  
  private let valueGetter: Observable<SoftResult<OutputValue, SomeError>>
  private let valueSetter: AnyObserver<InputValue?>
  private let doNotDisturbModeSetter: AnyObserver<DoNotDisturbMode>

  private let subviews: EditorViewControllerSubviews
  private let layout: EditorViewControllerLayout

  private let finalizeButtonContainer: LoadingButtonContainer
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: EditorViewControllerSubviews,
              layout: EditorViewControllerLayout,
              valueGetter: Observable<SoftResult<OutputValue, SomeError>>,
              valueSetter: AnyObserver<InputValue?>,
              doNotDisturbModeSetter: AnyObserver<DoNotDisturbMode> = .empty) {
    
    self.subviews = subviews
    self.layout = layout

    self.finalizeButtonContainer = subviews.finalizeButtonContainer
    
    self.valueGetter = valueGetter
    self.valueSetter = valueSetter
    self.doNotDisturbModeSetter = doNotDisturbModeSetter
    
    super.init(nibName: nil, bundle: nil)

    disposeBag {
      _isFinalizing ==> finalizeButtonContainer.isLoading
      _isFinalizing ==> view.rx.isUserInteractionDisabled
    }
  }
  
  override open func loadView() {
    let view = LayoutableView()
    self.view = view
    layout.setup(parentView: view, subviews: subviews)
  }
  
  open func setPresenter<Presenter: EditorPresenterProtocol>(_ presenter: Presenter)
  where
  Presenter.InputValue == InputValue,
  Presenter.OutputValue == OutputValue,
  Presenter.SomeError == SomeError {
    disposeBag {
      presenter.initialValue ==> valueSetter
      presenter.isFinalizeButtonEnabled ==> finalizeButtonContainer.isEnabled
      presenter.isFinalizing ==> isFinalizing
      presenter.doNotDisturbMode ==> doNotDisturbModeSetter
      presenter.hint ==> finalizeButtonContainer.hint

      // TODO: hide error message after raw value has been changed
      presenter.errorText ==> finalizeButtonContainer.errorText

      Observable
        .combineLatest(valueGetter, _externalValidator)
        .flatMap { $0.validate(via: $1) } ==> presenter.value

      finalizeButtonContainer.buttonTap ==> presenter.finalizeButtonTap
    }

    subviews.closeButton?.tap
      .subscribe(presenter.closeButtonTap)
      .disposed(by: disposeBag)
  }
}


private extension SoftResult {

  func validate(via validator: AsyncValidator<Success, Failure>) -> Single<Self> {
    switch self {
    case .success(let value):
      return validator(value)
    case .hybrid(let value, let error):
      return validator(value).map {
        switch $0 {
        case .success(let validatedValue):
          return .hybrid(value: validatedValue, error: error)
        default:
          return $0
        }
      }
    case .failure(let error):
      return .just(.failure(error))
    }
  }

  func externalError(from validator: @escaping AsyncValidator<Success, Failure>) -> Single<Failure?> {
    switch self {
    case .success(let value):
      return validator(value).map { $0.error }
    default:
      return .just(nil)
    }
  }
}
