//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class EditorViewController<InputValue, OutputValue, SomeError: Error>: UIViewController {
  
  public var buttonTitle: AnyObserver<String?> { saveButtonContainer.title }
  
  @RxUiInput(false) public var isSaving: AnyObserver<Bool>
  public var saveButtonTap: Observable<Void> { saveButtonContainer.buttonTap }
  
  private let valueGetter: Observable<Result<OutputValue, SomeError>>
  private let valueSetter: AnyObserver<InputValue?>
  
  private let editorView: UIView
  private let saveButtonContainer: LoadingButtonContainer
  private let spacing: CGFloat
  
  private let initScrollView: (UIView) -> UIScrollView
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(editorView: UIView,
              saveButtonContainer: LoadingButtonContainer,
              spacing: CGFloat,
              initScrollView: @escaping (UIView) -> UIScrollView,
              valueGetter: Observable<Result<OutputValue, SomeError>>,
              valueSetter: AnyObserver<InputValue?>) {
    
    self.editorView = editorView
    self.saveButtonContainer = saveButtonContainer
    self.spacing = spacing
    
    self.initScrollView = initScrollView
    
    self.valueGetter = valueGetter
    self.valueSetter = valueSetter
    
    super.init(nibName: nil, bundle: nil)
    
    valueGetter
      .map { if case .success = $0 { return true } else { return false } }
      .bind(to: saveButtonContainer.isEnabled)
      .disposed(by: disposeBag)
    
    _isSaving
      .bind(to: saveButtonContainer.isLoading)
      .disposed(by: disposeBag)
    
    _isSaving
      .bind(to: view.rx.isUserInteractionDisabled)
      .disposed(by: disposeBag)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    buildInterface()
  }
  
  private func buildInterface() {
    let scrollableView = AutoshrinkingScrollableView(
      contentView:
      .vstack(spacing: spacing, [
        editorView,
        saveButtonContainer
      ]),
      scrollView: initScrollView
    )
    
    view.putSubview(scrollableView)
  }
  
  public func setPresenter<Presenter: EditorPresenterProtocol>(_ presenter: Presenter)
    where
    Presenter.InputValue == InputValue,
    Presenter.OutputValue == OutputValue,
    Presenter.SomeError == SomeError {
      [
        presenter.initialValue.drive(valueSetter),
        presenter.isSaveButtonEnabled.drive(saveButtonContainer.isEnabled),
        
        presenter.isSaving.drive(isSaving),
        // TODO: hide error message after raw value has been changed
        presenter.errorText.drive(saveButtonContainer.errorText),
        
        valueGetter.bind(to: presenter.value),
        saveButtonContainer.buttonTap.bind(to: presenter.saveButtonTap)
      ]
      .disposed(by: disposeBag)
  }
}
