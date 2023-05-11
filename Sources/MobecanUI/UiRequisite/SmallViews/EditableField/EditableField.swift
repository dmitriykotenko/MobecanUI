// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class EditableField<RawValue, ValidatedValue, ValidationError: Error>: LayoutableControl, MandatorinessListener {
  
  @RxUiInput(.empty) open var texts: AnyObserver<EditableFieldTexts>
  @RxUiInput open var initialRawValue: AnyObserver<RawValue>
  @RxUiInput(.on) open var doNotDisturbMode: AnyObserver<DoNotDisturbMode>
  @RxUiInput(nil) open var externalError: AnyObserver<ValidationError?>
  @RxUiInput(false) open var isMandatory: AnyObserver<Bool>
  
  open var rxIsFocused: Driver<Bool> { (focusableView ?? valueEditor).rx.isFirstResponder }

  // MARK: - Value
  open private(set) var rawValue: ControlProperty<RawValue>
  open private(set) lazy var validatedValue = rawValue.compactMap { [weak self] in self?.validator($0) }
  open private(set) var selectNextField: Observable<Void>
  
  // MARK: - Reactive counterpart of .isEnabled property
  private var rxIsEnabled = BehaviorRelay(value: true)
  
  // MARK: - Error
  private lazy var errorToShow: Observable<ValidationError?> = Observable
    .combineLatest(
    validatedValue,
    _externalError,
    _doNotDisturbMode
    ) { validatedValue, externalError, doNotDisturbMode in
      switch doNotDisturbMode {
      case .on:
        return nil
      case .off:
        return validatedValue.error ?? externalError
      }
  }
  
  // MARK: - Subviews
  private let titleLabel: UILabel
  private let hintLabel: UILabel
  private let errorLabel: UILabel
  private let backgroundView: EditableFieldBackgroundProtocol
  private let valueEditor: UIView

  /// Необязательная часть ``EditableField``, которая становится firstResponder-ом в начале редактирования поля.
  ///
  /// Обычно это UITextField или UITextView.
  ///
  /// Явное указание этой вьюшки нужно для более быстрой работы ``EditableField``.
  private let focusableView: UIView?
  
  open var formatError: (ValidationError) -> String? = { "\($0.localizedDescription)" }
  private let validator: (RawValue) -> SoftResult<ValidatedValue, ValidationError>
  private var firstResponderStatusListener: [NSObjectProtocol] = []
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(subviews: EditableFieldSubviews,
              layout: EditableFieldLayout,
              rawValueGetter: Observable<RawValue>,
              rawValueSetter: AnyObserver<RawValue>,
              validator: @escaping (RawValue) -> SoftResult<ValidatedValue, ValidationError>,
              selectNextField: Observable<Void> = .never()) {
    self.titleLabel = subviews.titleLabel
    self.hintLabel = subviews.hintLabel
    self.errorLabel = subviews.errorLabel
    self.backgroundView = subviews.background
    self.valueEditor = subviews.valueEditor
    self.focusableView = subviews.focusableView
    
    self.rawValue = ControlProperty(values: rawValueGetter, valueSink: rawValueSetter)
    self.validator = validator
    self.selectNextField = selectNextField
    
    super.init()

    setupLayout(subviews: subviews, layout: layout)
    
    setupTitle()
    setupPlaceholder()
    setupHintAndError()
    setupMandatoriness(subviews: subviews)
    setupBackground()
    
    setupInitialValue()
  }
  
  private func setupLayout(subviews: EditableFieldSubviews,
                           layout: EditableFieldLayout) {
    self.layout = layout.mainSubview(subviews).asLayout
  }
  
  private func setupTitle() {
    let title = _texts.map { $0.title }
    
    disposeBag {
      title ==> titleLabel.rx.text
      title.map(\.isNilOrEmpty) ==> titleLabel.rx.isHidden
    }
  }
  
  private func setupPlaceholder() {
    if let placeholderContainer = valueEditor as? PlaceholderContainer {
      disposeBag {
        _texts.map(\.placeholder) ==> placeholderContainer.rxPlaceholder
      }
    }
  }

  private func setupHintAndError() {
    let errorText = errorToShow.nestedFlatMap { [weak self] in self?.formatError($0) }

    let hintText = Observable
      .combineLatest(errorToShow, _texts) { error, texts in
        error == nil ? texts.hint : nil
      }
      
    disposeBag {
      errorText ==> errorLabel.rx.text
      errorText.map(\.isNilOrEmpty) ==> errorLabel.rx.isHidden
      hintText ==> hintLabel.rx.text
      hintText.map(\.isNilOrEmpty) ==> hintLabel.rx.isHidden
    }
  }

  private func setupMandatoriness(subviews: EditableFieldSubviews) {
    let listeners = subviews.all
      .compactMap { $0 as? MandatorinessListener }
      .map { $0.isMandatory }

    listeners.forEach { listener in
      disposeBag { _isMandatory ==> listener }
    }
  }
  
  private func setupBackground() {
    disposeBag {
      backgroundView.state <==
        .combineLatest(rxIsEnabled, rxIsFocused.asObservable(), errorToShow) {
          EditableFieldBackgroundState(
            isEnabled: $0,
            isFocused: $1,
            error: $2
          )
        }
        .distinctUntilChanged()
    }
  }
  
  private func setupInitialValue() {
    disposeBag {
      _initialRawValue ==> rawValue
    }
  }
  
  override open var isEnabled: Bool { didSet { rxIsEnabled.accept(isEnabled) } }
  
  @discardableResult
  open func startEditing() -> Bool {
    (focusableView ?? valueEditor).becomeFirstResponder()
  }
  
  @discardableResult
  open func endEditing() -> Bool {
    (focusableView ?? valueEditor).resignFirstResponder()
  }
}
