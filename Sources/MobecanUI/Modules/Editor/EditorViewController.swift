//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class EditorViewController<InputValue, OutputValue, SomeError: Error>: UIViewController {

  open var buttonTitle: AnyObserver<String?> { saveButtonContainer.title }
  
  @RxUiInput(false) open var isSaving: AnyObserver<Bool>
  open var saveButtonTap: Observable<Void> { saveButtonContainer.buttonTap }

  @RxUiInput({ .just(.success($0)) }) open var externalValidator: AnyObserver<AsyncValidator<OutputValue, SomeError>>

  open var externalError: Driver<SomeError?> {
    Observable
      .combineLatest(valueGetter, _externalValidator)
      .flatMap { $0.externalError(from: $1) }
      .asDriver(onErrorDriveWith: .never())
  }
  
  private let valueGetter: Observable<Result<OutputValue, SomeError>>
  private let valueSetter: AnyObserver<InputValue?>
  private let doNotDisturbModeSetter: AnyObserver<DoNotDisturbMode>

  private let subviews: EditorViewControllerSubviews
  private let layout: EditorViewControllerLayout

  private let saveButtonContainer: LoadingButtonContainer
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: EditorViewControllerSubviews,
              layout: EditorViewControllerLayout,
              valueGetter: Observable<Result<OutputValue, SomeError>>,
              valueSetter: AnyObserver<InputValue?>,
              doNotDisturbModeSetter: AnyObserver<DoNotDisturbMode> = .empty) {
    
    self.subviews = subviews
    self.layout = layout

    self.saveButtonContainer = subviews.saveButtonContainer
    
    self.valueGetter = valueGetter
    self.valueSetter = valueSetter
    self.doNotDisturbModeSetter = doNotDisturbModeSetter
    
    super.init(nibName: nil, bundle: nil)

    disposeBag {
      _isSaving ==> saveButtonContainer.isLoading
      _isSaving ==> view.rx.isUserInteractionDisabled
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
      presenter.isSaveButtonEnabled ==> saveButtonContainer.isEnabled
      presenter.isSaving ==> isSaving
      presenter.doNotDisturbMode ==> doNotDisturbModeSetter
      presenter.hint ==> saveButtonContainer.hint

      // TODO: hide error message after raw value has been changed
      presenter.errorText ==> saveButtonContainer.errorText

      Observable
        .combineLatest(valueGetter, _externalValidator)
        .flatMap { $0.validate(via: $1) } ==> presenter.value

      saveButtonContainer.buttonTap ==> presenter.saveButtonTap
    }
  }
}


private extension Result {

  func validate(via validator: AsyncValidator<Success, Failure>) -> Single<Self> {
    switch self {
    case .success(let value):
      return validator(value)
    case .failure(let error):
      return .just(.failure(error))
    }
  }

  func externalError(from validator: @escaping AsyncValidator<Success, Failure>) -> Single<Failure?> {
    switch self {
    case .success(let value):
      return validator(value).map { $0.asError }
    case .failure:
      return .just(nil)
    }
  }
}
