// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class EditorModule<InputValue, OutputValue, SomeError: Error>: Module {

  public struct Parts {
    public let interactor: EditorInteractor<InputValue, OutputValue, SomeError>
    public let presenter: EditorPresenter<InputValue, OutputValue, SomeError>
    public let view: EditorViewController<InputValue, OutputValue, SomeError>

    public init(interactor: EditorInteractor<InputValue, OutputValue, SomeError>,
                presenter: EditorPresenter<InputValue, OutputValue, SomeError>,
                view: EditorViewController<InputValue, OutputValue, SomeError>) {
      self.interactor = interactor
      self.presenter = presenter
      self.view = view
    }
  }

  open var finished: Observable<Void> {
    .merge(
      interactor.close,
      interactor.finalizationStatus.asSuccess().mapToVoid()
    )
  }

  /// Результат последней финализации.
  open var finalEditingResult: Single<Result<OutputValue, SomeError>> {
    interactor.finalizationStatus.compactMap(\.?.asResult).takeLast(1).asSingle()
  }

  /// Если пользователь закрыл модуль без финализации, возвращает `.cancel`.
  /// Во всех остальных случаях возвращает результат последней финализации.
  open var finalEditingResultOrCancel: Single<CancelOr<Result<OutputValue, SomeError>>> {
    Observable.merge(
      interactor.close.map { .cancel },
      interactor.finalizationStatus.compactMap(\.?.asResult)
        .takeLast(1)
        .map { .value($0) }
    )
    .take(1).asSingle()
  }

  /// Результат обработки промежуточного значения.
  open var intermediateValueProcessingResult: Observable<Result<OutputValue, SomeError>> {
    interactor.intermediateValueProcessingStatus.compactMap(\.?.asResult)
  }

  /// Финальное значение, получившееся в результате первой успешной финализации.
  open var finalValue: Single<OutputValue> {
    interactor.finalizationStatus.asSuccess().take(1).asSingle()
  }

  /// Если пользователь закрыл модуль без финализации, возвращает `.cancel`.
  /// Во всех остальных случаях возвращает финальное значение.
  open var finalValueOrCancel: Single<CancelOr<OutputValue>> {
    Observable.merge(
      interactor.close.map { .cancel },
      interactor.finalizationStatus.asSuccess().map { .value($0) }
    )
    .take(1).asSingle()
  }

  /// Промежуточное выходное значение.
  open var intermediateValue: Observable<OutputValue> {
    interactor.intermediateValueProcessingStatus.asSuccess()
  }

  open var viewController: UIViewController { view }

  private let interactor: EditorInteractor<InputValue, OutputValue, SomeError>
  private let presenter: EditorPresenter<InputValue, OutputValue, SomeError>
  private let view: EditorViewController<InputValue, OutputValue, SomeError>

  public var demonstrator: Demonstrator?

  public convenience init(parts: Parts) {
    self.init(parts: parts, demonstrator: nil)
  }

  public init(parts: Parts,
              demonstrator: Demonstrator?) {
    self.interactor = parts.interactor
    self.presenter = parts.presenter
    self.view = parts.view

    self.demonstrator = demonstrator ??
    UiKitDemonstrator(parentViewController: parts.view)

    presenter.setInteractor(interactor)
    view.setPresenter(presenter)
  }

  @discardableResult
  open func with(initialValue: Observable<InputValue?>) -> Self {
    interactor.with(initialValue: initialValue)
    return self
  }

  @discardableResult
  open func with(initialValue: InputValue?) -> Self {
    with(initialValue: .just(initialValue))
  }

  @discardableResult
  open func with(finalizer: AsyncProcessor<OutputValue, SomeError>) -> Self {
    interactor.finalizer = finalizer
    return self
  }

  @discardableResult
  open func with(intermediateValueProcessingPolicy: IntermediateValueProcessingPolicy<OutputValue, SomeError>) -> Self {
    interactor.intermediateValueProcessingPolicy = intermediateValueProcessingPolicy
    return self
  }

  @discardableResult
  open func with(externalValidator: @escaping AsyncValidator<OutputValue, SomeError>) -> Self {
    view.externalValidator.onNext(externalValidator)
    return self
  }

  @discardableResult
  open func with(buttonTitle: String?) -> Self {
    view.buttonTitle.onNext(buttonTitle)
    return self
  }
}


private extension ObservableType {

  func asSuccess<Value, SomeError: Error>() -> Observable<Value> where Element == Loadable<Value, SomeError>? {
    // Нельзя использовать .compactMap(\.?.asSuccess) из-за неоднозначности optional unwrapping в Свифте.
    //
    // Неоднозначность возникает, когда ``Value`` само по себе Optional.
    compactMap {
      switch $0 {
      case .loaded(.success(let value)):
        return value
      default:
        return nil
      }
    }
  }
}
