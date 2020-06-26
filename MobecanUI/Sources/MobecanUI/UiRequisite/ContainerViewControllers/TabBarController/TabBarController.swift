//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SwiftDateTime
import UIKit


public class TabBarController: UIViewController {

  @RxUiInput public var selectTab: AnyObserver<Tab>
  public var selectedTab: Driver<Tab> { tabBar.selectedTab.filterNil() }
  public var tabTap: Observable<Tab> { tabBar.tabTap.asObservable() }

  @RxUiInput public var floatingViewController: AnyObserver<UIViewController?>
  public var isFloatingViewHidden: AnyObserver<Bool> { floatingView.rx.isHidden.asObserver() }

  private var selectedViewController: UIViewController?
  
  private let tabBar: TabBar
  private let contentView = UIView()
  private let floatingView = ClickThroughView()

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

    addContentView()
    addFloatingView()
    addTabBar()
  }
  
  private func addContentView() {
    view.addSubview(contentView)
    
    contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
  }
  
  private func addFloatingView() {
    view.addSubview(floatingView)
    
    floatingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    
    _floatingViewController
      .distinctUntilChanged()
      .filterNil()
      .subscribe(onNext: { [weak self] in self?.addFloatingViewController($0) })
      .disposed(by: disposeBag)

    _floatingViewController
      .distinctUntilChanged()
      .filter { $0 == nil }
      .withLatestFrom(_floatingViewController.previous.filterNil())
      .subscribe(onNext: { [weak self] in self?.removeFloatingViewController($0) })
      .disposed(by: disposeBag)
  }
  
  private func addTabBar() {
    view.addSubview(tabBar)
    
    tabBar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    tabBar.tabTap.debug("Tab-Tap")
      .emit(to: selectTab)
      .disposed(by: disposeBag)
    
    _selectTab
      .subscribe(onNext: { [weak self] in self?.select(viewController: $0.viewController) })
      .disposed(by: disposeBag)
    
    _selectTab
      .bind(to: tabBar.selectTab)
      .disposed(by: disposeBag)
  }
  
  public func setTabs(_ tabs: [Tab]) {
    tabBar.visibleTabs.onNext(tabs)
  }
  
  public func select(viewController: UIViewController) {
    guard viewController != selectedViewController else { return }
    
    selectedViewController?.willMove(toParent: nil)
    addChild(viewController)
    contentView.addSingleSubview(viewController.view)
    
    selectedViewController?.view.removeFromSuperview()    
    viewController.didMove(toParent: self)
    selectedViewController?.didMove(toParent: nil)
    
    selectedViewController = viewController
  }
  
  public func addFloatingViewController(_ floatingViewController: UIViewController) {
    floatingViewController.willMove(toParent: self)
    floatingView.addSingleSubview(floatingViewController.view)
    addChild(floatingViewController)
  }
  
  public func removeFloatingViewController(_ floatingViewController: UIViewController) {
    floatingViewController.willMove(toParent: nil)    
    floatingViewController.view.removeFromSuperview()
    floatingViewController.didMove(toParent: nil)
  }
}
