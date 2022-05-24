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

  /// Result of first saving.
  open var editingResult: Single<Result<OutputValue, SomeError>> {
    interactor.savingStatus.compactMap(\.?.asResult).take(1).asSingle()
  }

  /// Final value produced by first successful saving.
  open var finalValue: Single<OutputValue> {
    interactor.savingStatus.asSuccess().take(1).asSingle()
  }

  open var finished: Observable<Void> {
    interactor.savingStatus.asSuccess().mapToVoid()
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
  
  open func with(initialValue: Observable<InputValue?>) -> Self {
    interactor.with(initialValue: initialValue)
    return self
  }
  
  open func with(saver: Saver<OutputValue, SomeError>) -> Self {
    interactor.saver = saver
    return self
  }

  open func with(externalValidator: @escaping AsyncValidator<OutputValue, SomeError>) -> Self {
    view.externalValidator.onNext(externalValidator)
    return self
  }

  open func with(buttonTitle: String?) -> Self {
    view.buttonTitle.onNext(buttonTitle)
    return self
  }
}


private extension ObservableType {

  func asSuccess<Value, SomeError: Error>() -> Observable<Value> where Element == Loadable<Value, SomeError>? {
    // We can not use .compactMap(\.?.asSuccess) here because of ambigious optional unwrapping in Swift.
    //
    // Ambiguity appears when ``Value`` itself is an Optional.
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
