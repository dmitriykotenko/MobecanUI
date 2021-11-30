//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


/// Container view controller which emits reactive signals on every life-cycle event.
///
/// Intended to track dismissals when presenting view controllers.
open class LifecycleBroadcasterViewController: UIViewController {

  @RxSignalOutput open var rxViewDidLoad: Signal<Void>
  @RxSignalOutput open var rxViewWillAppear: Signal<Void>
  @RxSignalOutput open var rxViewDidAppear: Signal<Void>
  @RxSignalOutput open var rxViewWillDisappear: Signal<Void>
  @RxSignalOutput open var rxViewDidDisappear: Signal<Void>

  /// The view controller was dismissed after being presented by another view controller.
  open var rxViewDidDismiss: Signal<Void> {
    rxViewDidDisappear
      .filter { [weak self] in self?.isBeingDismissed == true }
      .asObservable()
      // Wait for dismissal to completely finish:
      // view should be removed from superview,
      // parentViewController and presentingViewController should become nil.
      .observe(on: MainScheduler.asyncInstance)
      .asSignal(onErrorSignalWith: .empty())
  }

  private let child: UIViewController

  required public init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(child: UIViewController) {
    self.child = child

    super.init(nibName: nil, bundle: nil)
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)

    _rxViewDidLoad.onNext(())
  }

  override open func viewWillLayoutSubviews() {
    view.subviews.forEach { $0.frame = view.bounds }
  }

  override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    _rxViewWillAppear.onNext(())
  }

  override open func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    _rxViewDidAppear.onNext(())
  }

  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    _rxViewWillDisappear.onNext(())
  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    _rxViewDidDisappear.onNext(())
  }
}
