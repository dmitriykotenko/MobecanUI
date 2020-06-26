//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class EditorModule<InputValue, OutputValue, SomeError: Error>: Module {

  public lazy var finished: Observable<Void> = interactor.valueSaved.filterSuccess().mapToVoid()
  public var viewController: UIViewController { view }

  private let interactor: EditorInteractor<InputValue, OutputValue, SomeError>
  private let presenter: EditorPresenter<InputValue, OutputValue, SomeError>
  private let view: EditorViewController<InputValue, OutputValue, SomeError>

  public init(interactor: EditorInteractor<InputValue, OutputValue, SomeError>,
              presenter: EditorPresenter<InputValue, OutputValue, SomeError>,
              view: EditorViewController<InputValue, OutputValue, SomeError>) {
    self.interactor = interactor
    self.presenter = presenter
    self.view = view

    presenter.setInteractor(interactor)
    view.setPresenter(presenter)
  }
  
  func with(initialValue: Observable<InputValue?>) -> Self {
    interactor.with(initialValue: initialValue)
    return self
  }
  
  func with(saver: Saver<OutputValue, SomeError>) -> Self {
    interactor.saver.onNext(saver)
    return self
  }
  
  func with(buttonTitle: String?) -> Self {
    view.buttonTitle.onNext(buttonTitle)
    return self
  }
}
