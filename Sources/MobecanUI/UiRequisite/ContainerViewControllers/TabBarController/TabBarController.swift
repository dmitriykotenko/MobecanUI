// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


open class TabBarController: UIViewController {

  open var visibleTabs: AnyObserver<[Tab]> { tabBar.visibleTabs }
  @RxUiInput open var selectTab: AnyObserver<Tab>

  open var selectedTab: Driver<Tab> { tabBar.selectedTab.filterNil() }
  open var tabTap: Observable<Tab> { tabBar.tabTap.asObservable() }

  @RxUiInput open var floatingViewController: AnyObserver<UIViewController?>
  open var isFloatingViewHidden: AnyObserver<Bool> { floatingView.rx.isHidden.asObserver() }

  private var selectedViewController: UIViewController?
  
  private let tabBar: TabBar
  private let contentView = LayoutableView()
  private let floatingView = LayoutableView().clickThrough()

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(tabBar: TabBar,
              backgroundColor: UIColor) {
    self.tabBar = tabBar
    
    super.init(nibName: nil, bundle: nil)
    
    view.backgroundColor = backgroundColor
    
    additionalSafeAreaInsets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: tabBar.contentHeight,
      right: 0
    )

    setupFloatingView()
    setupTabBar()
  }

  override open func loadView() {
    view = .zstack([
      contentView,
      .bottom(tabBar).clickThrough(),
      floatingView
    ])
  }

  override open func viewWillLayoutSubviews() {
    // Tab-bar needs safe area insets provider to correctly compute its size and subviews placement.
    tabBar.safeAreaInsetsProvider = view?.superview

    super.viewWillLayoutSubviews()
  }

  private func setupFloatingView() {
    disposeBag {
      _floatingViewController
        .distinctUntilChanged()
        .filterNil() ==> { [weak self] in self?.addFloatingViewController($0) }

      _floatingViewController
        .distinctUntilChanged()
        .whenIsEqual(to: nil)
        .withLatestFrom(_floatingViewController.previous.filterNil()) ==> { [weak self] in
          self?.removeFloatingViewController($0)
        }
    }
  }
  
  private func setupTabBar() {
    disposeBag {
      tabBar.tabTap ==> selectTab

      _selectTab ==> { [weak self] in self?.select(viewController: $0.viewController) }
      _selectTab ==> tabBar.selectTab
    }
  }
  
  open func setTabs(_ tabs: [Tab]) {
    tabBar.visibleTabs.onNext(tabs)
  }
  
  open func select(viewController: UIViewController) {
    guard viewController != selectedViewController else { return }
    
    selectedViewController?.willMove(toParent: nil)
    addChild(viewController)
    contentView.layout = InsetLayout<UIView>.fromSingleSubview(viewController.view)

    selectedViewController?.view.removeFromSuperview()    
    viewController.didMove(toParent: self)
    selectedViewController?.removeFromParent()
    
    selectedViewController = viewController
    view.setNeedsLayout()
  }
  
  open func addFloatingViewController(_ floatingViewController: UIViewController) {
    addChild(floatingViewController)

    floatingView.layout = InsetLayout<UIView>.fromSingleSubview(floatingViewController.view)
    
    floatingViewController.didMove(toParent: self)
    view.setNeedsLayout()
  }
  
  open func removeFloatingViewController(_ floatingViewController: UIViewController) {
    floatingViewController.willMove(toParent: nil)    
    floatingViewController.view.removeFromSuperview()
    floatingViewController.removeFromParent()

    floatingView.layout = EmptyLayout()
    view.setNeedsLayout()
  }
}
