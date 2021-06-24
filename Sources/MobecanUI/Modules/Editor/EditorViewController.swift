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

    [
      _isSaving.bind(to: saveButtonContainer.isLoading),
      _isSaving.bind(to: view.rx.isUserInteractionDisabled)
    ]
    .disposed(by: disposeBag)
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    buildInterface()
  }
  
  private func buildInterface() {
    layout.setup(parentView: view, subviews: subviews)
  }
  
  open func setPresenter<Presenter: EditorPresenterProtocol>(_ presenter: Presenter)
  where
  Presenter.InputValue == InputValue,
  Presenter.OutputValue == OutputValue,
  Presenter.SomeError == SomeError {
    [
      presenter.initialValue.drive(valueSetter),

      presenter.isSaveButtonEnabled.drive(saveButtonContainer.isEnabled),
      presenter.isSaving.drive(isSaving),

      presenter.doNotDisturbMode.drive(doNotDisturbModeSetter),
      presenter.hint.drive(saveButtonContainer.hint),
      // TODO: hide error message after raw value has been changed
      presenter.errorText.drive(saveButtonContainer.errorText),

      Observable
        .combineLatest(valueGetter, _externalValidator)
        .flatMap { $0.validate(via: $1) }
        .bind(to: presenter.value),

      saveButtonContainer.buttonTap.bind(to: presenter.saveButtonTap)
    ]
    .disposed(by: disposeBag)
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
