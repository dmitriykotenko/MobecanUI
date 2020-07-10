//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


open class EditorModule<InputValue, OutputValue, SomeError: Error>: Module {

  public struct Parts {
    public let interactor: EditorInteractor<InputValue, OutputValue, SomeError>
    public let presenter: EditorPresenter<InputValue, OutputValue, SomeError>
    public let view: EditorViewController<InputValue, OutputValue, SomeError>
  }

  open var editingResult: Single<Result<OutputValue, SomeError>> { interactor.valueSaved.take(1).asSingle() }

  open var finished: Observable<Void> { interactor.valueSaved.filterSuccess().mapToVoid() }
  
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
    interactor.saver.onNext(saver)
    return self
  }
  
  open func with(buttonTitle: String?) -> Self {
    view.buttonTitle.onNext(buttonTitle)
    return self
  }
}
