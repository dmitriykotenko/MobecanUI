// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class NavigationViewController: UIViewController {

  private let worker: NavigationController
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(worker: NavigationController) {
    self.worker = worker
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override open func viewDidLoad() {
    super.viewDidLoad()

    buildInterface()
  }

  private func buildInterface() {
    worker.willMove(toParent: self)
    
    view.putSubview(worker.view)
    
    addChild(worker)
  }

  open func setPresenter(_ presenter: NavigationPresenterProtocol) {
    disposeBag {
      presenter.events ==> { [weak self] in self?.worker.set(children: $0, animated: $1) }
      worker.viewControllers ==> presenter.viewControllers
      worker.backButtonTap ==> presenter.backButtonTap
    }
  }
}
