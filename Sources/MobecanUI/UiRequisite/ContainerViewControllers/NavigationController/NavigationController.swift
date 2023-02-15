// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import SwiftDateTime
import UIKit


open class NavigationController: UIViewController {
  
  public var close: Observable<Void> {
    customNavigationBar.leftButtonTap
      .filterWith(viewControllers.map { $0.count <= 1 })
      .mapToVoid()
    }
  
  public var backButtonTap: Observable<Void> { customNavigationBar.leftButtonTap }
  
  /// Value is updated at the end of navigation animation.
  @RxOutput([]) public var viewControllers: Observable<[UIViewController]>
  
  /// Value is updated at the beginning of navigation animation.
  @RxOutput public var futureViewControllers: Observable<[UIViewController]>

  private let customNavigationBar: NavigationBar
  private let backButtonStrategy: BackButtonStrategy

  private let contentView = ClickThroughView()

  @RxDriverOutput(nil) private var appearingViewController: Driver<UIViewController?>

  private lazy var navigationBarContentListener =
    NavigationBarContentListener(appearingViewController: appearingViewController)

  private lazy var navigationBarFrameListener = FramesListener(views: [customNavigationBar])

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(navigationBar: NavigationBar,
              backButtonStrategy: BackButtonStrategy = .backOrCloseOrNone) {
    self.customNavigationBar = navigationBar
    self.backButtonStrategy = backButtonStrategy
    
    super.init(nibName: nil, bundle: nil)
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    buildInterface()
  }
  
  private func buildInterface() {
    addContentView()
    addCustomNavigationBar()
  }
  
  private func addContentView() {
    view.putSubview(contentView)
  }
  
  private func addCustomNavigationBar() {
    view.addSubview(customNavigationBar)
    
    customNavigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view)
    }
    
    setupSafeArea()
    setupNavigationBarContent()
  }
  
  private func setupNavigationBarContent() {
    disposeBag {
      navigationBarContentListener.content ==> customNavigationBar.content

      appearingViewController
        .map(\.?.view.backgroundColor)
        ==> customNavigationBar.screenBackgroundColor
    }
  }
  
  private func setupSafeArea() {
    if customNavigationBar.affectsSafeArea {
      disposeBag {
        navigationBarFrameListener
          .framesChanged
          .observe(on: MainScheduler.instance)
          .compactMap { [weak self] in self?.customNavigationBar.frame.height }
          ==> { [weak self] in self?.additionalSafeAreaInsets = .top($0) }
      }
    } else {
      additionalSafeAreaInsets = .zero
    }
  }

  public func push(_ viewController: UIViewController,
                   animated: Bool) {
    modifyChildren(animated) { $0 + [viewController] }
  }
  
  public func pop(animated: Bool) {
    modifyChildren(animated) { $0.dropLast() }
  }
  
  public func popTo(_ viewController: UIViewController,
                    animated: Bool) {
    modifyChildren(animated) { $0.prefix(upToElement: viewController) }
  }
  
  public func set(children: [UIViewController],
                  animated: Bool) {
    print("Navigation-controller Set children: \(children).")
    modifyChildren(animated) { _ in children }
  }
  
  private func modifyChildren(_ animated: Bool,
                              modificator: @escaping ([UIViewController]) -> [UIViewController]) {
    disposeBag {
      Observable.just(modificator)
        .withLatestFrom(viewControllers) { ChildrenUpdate(old: $1, new: $0($1), animated: animated) }
        ==> { [weak self] in
          self?.updateNavigationBar($0)
          self?.updateChildren($0)
        }
    }
  }
  
  private func updateNavigationBar(_ update: ChildrenUpdate) {
    _appearingViewController.onNext(update.new.last)
    
    customNavigationBar.backButtonStyle.onNext(
      backButtonStrategy.backButtonStyle(viewControllers: update.new)
    )
  }

  private func updateChildren(_ update: ChildrenUpdate) {
    let oldViewController = update.old.last
    let newViewController = update.new.last

    oldViewController?.willMove(toParent: nil)
    
    newViewController.map {
      addChild($0)
      contentView.putSubview($0.view)
    }
    
    _futureViewControllers.onNext(update.new)
    
    let animator = NavigationAnimator(navigationView: view, animationDuration: .systemAnimation)
    
    animator.performAnimation(
      update.animation,
      from: oldViewController,
      to: newViewController,
      completion: { [weak self] in
        oldViewController?.view.removeFromSuperview()
        oldViewController?.removeFromParent()
        newViewController?.didMove(toParent: self)
        
        self?._viewControllers.onNext(update.new)
      }
    )
  }
  
  private struct ChildrenUpdate {
    
    let old: [UIViewController]
    let new: [UIViewController]
    let animated: Bool
    
    var animation: NavigationAnimator.Animation {
      !animated ? .none :
        old.isEmpty ? .none :
        new.starts(with: old) ? .push :
        old.starts(with: new) ? .pop :
        .push
    }
  }
}


public extension NavigationController {
  
  @discardableResult
  func setPresenter(_ presenter: OldNavigationPresenterProtocol) -> Single<Void> {
    // Subscribing to presenter's outputs (usually these are Drivers and Signals)
    // must be called in main thread
    performInMainThread {
      self.bindTo(presenter)
    }
  }
  
  private func bindTo(_ presenter: OldNavigationPresenterProtocol) {
    disposeBag {
      presenter.push ==> { [weak self] in self?.push($0, animated: true) }
      presenter.pop ==> { [weak self] in self?.pop(animated: true) }
      presenter.popTo ==> { [weak self] in self?.popTo($0, animated: true) }
      presenter.set ==> { [weak self] in self?.set(children: $0, animated: true) }
      presenter.setInitial ==> { [weak self] in self?.set(children: [$0], animated: false) }
      
      presenter.dismiss ==> { [weak self] in self?.dismiss(animated: true, completion: nil) }
      
      backButtonTap ==> presenter.backButtonTap
    }
  }
}
