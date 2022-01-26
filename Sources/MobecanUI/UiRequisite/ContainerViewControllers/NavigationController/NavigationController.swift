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
    navigationBarContentListener
      .content
      .drive(customNavigationBar.content)
      .disposed(by: disposeBag)
    
    appearingViewController
      .map { $0?.view.backgroundColor }
      .drive(customNavigationBar.screenBackgroundColor)
      .disposed(by: disposeBag)
  }
  
  private func setupSafeArea() {
    if customNavigationBar.affectsSafeArea {
      navigationBarFrameListener
        .framesChanged
        .observe(on: MainScheduler.instance)
        .compactMap { [weak self] in self?.customNavigationBar.frame.height }
        .subscribe(onNext: { [weak self] in self?.additionalSafeAreaInsets = .top($0) })
        .disposed(by: disposeBag)
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
    Observable.just(modificator)
      .withLatestFrom(viewControllers) { ChildrenUpdate(old: $1, new: $0($1), animated: animated) }
      .subscribe(onNext: { [weak self] in
        self?.updateNavigationBar($0)
        self?.updateChildren($0)
      })
      .disposed(by: disposeBag)
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
        oldViewController?.didMove(toParent: nil)
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
    // .emit() and .drive() methods must be called in main thread
    performInMainThread {
      self.bindTo(presenter)
    }
  }
  
  private func bindTo(_ presenter: OldNavigationPresenterProtocol) {
    [
      presenter.push.emit(onNext: { [weak self] in self?.push($0, animated: true) }),
      presenter.pop.emit(onNext: { [weak self] in self?.pop(animated: true) }),
      presenter.popTo.emit(onNext: { [weak self] in self?.popTo($0, animated: true) }),
      presenter.set.emit(onNext: { [weak self] in self?.set(children: $0, animated: true) }),
      presenter.setInitial.emit(onNext: { [weak self] in self?.set(children: [$0], animated: false) }),
      
      presenter.dismiss.emit(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) }),
      
      backButtonTap.bind(to: presenter.backButtonTap)
    ]
    .disposed(by: disposeBag)
  }
}
