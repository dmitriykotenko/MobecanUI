import XCTest

import RxCocoa
import RxSwift
import RxTest

@testable import MobecanUI


final class NavigationBarContentListenerTests: XCTestCase {

  func testThatInitiallyContentIsEmpty() {
    check(
      viewController: [],
      expectedContent: [.next(0, .empty)]
    )
  }

  func testThatSystemTitleIsProcessedCorrectly() {
    check(
      viewController: [
        .next(0, SystemViewController(title: "A")),
        .next(10, SystemViewController(title: "B")),
      ],
      expectedContent: [
        .next(0, .empty),
        .next(0, .title(.string("A"))),
        .next(10, .title(.string("B"))),
      ]
    )
  }

  func testThatCustomTitleIsProcessedCorrectly() {
    check(
      viewController: [
        .next(0, CustomViewController(content: .just(.title(.string("A"))))),
        .next(10, CustomViewController(content: .just(.title(.string("B"))))),
      ],
      expectedContent: [
        .next(0, .empty),
        .next(0, .title(.string("A"))),
        .next(10, .title(.string("B"))),
      ]
    )
  }

  func testThatMixedTitleProcessedCorrectly() {
    check(
      viewController: [
        .next(0, SystemViewController(title: "A")),
        .next(10, CustomViewController(content: .just(.title(.string("1"))))),
        .next(20, SystemViewController(title: "B")),
        .next(30, SystemViewController(title: "C")),
        .next(40, CustomViewController(content: .just(.title(.string("2"))))),
      ],
      expectedContent: [
        .next(0, .empty),
        .next(0, .title(.string("A"))),
        .next(10, .title(.string("1"))),
        .next(20, .title(.string("B"))),
        .next(30, .title(.string("C"))),
        .next(40, .title(.string("2"))),
      ]
    )
  }

  func testThatDynamicCustomTitleProcessedCorrectly() {
    let scheduler = TestScheduler(initialClock: 0)
    
    let dynamicTitle: TestableObservable<NavigationBarContent> = scheduler.createHotObservable([
      .next(20, .title(.string("Z"))),
      .next(30, .title(.string("Y"))),
      .next(50, .title(.string("X"))),
      .next(70, .title(.string("W"))),
    ])
    
    let customViewController = CustomViewController(content: dynamicTitle.asObservable())
    
    check(
      viewController: [
        .next(0, SystemViewController(title: "???")),
        .next(10, customViewController),
        .next(60, SystemViewController(title: "!!!")),
      ],
      expectedContent: [
        .next(0, .empty),
        .next(0, .title(.string("???"))),
        .next(10, .empty),
        .next(20, .title(.string("Z"))),
        .next(30, .title(.string("Y"))),
        .next(50, .title(.string("X"))),
        .next(60, .title(.string("!!!"))),
      ],
      testScheduler: scheduler
    )
  }

  private func check(viewController: [Recorded<Event<UIViewController?>>],
                     expectedContent: [Recorded<Event<NavigationBarContent>>],
                     testScheduler: TestScheduler = TestScheduler(initialClock: 0)) {
    
    let appearingViewController = testScheduler.createHotObservable(viewController)
    
    let actualContent = testScheduler.createObserver(NavigationBarContent.self)
    
    let listener = NavigationBarContentListener(appearingViewController:
      appearingViewController.asDriver(onErrorJustReturn: UIViewController(nibName: nil, bundle: nil))
    )
    
    let disposeBag = DisposeBag()
    
    listener.content.asObservable().bind(to: actualContent).disposed(by: disposeBag)
    
    testScheduler.start()
    
    XCTAssertEqual(
      actualContent.events,
      expectedContent
    )
  }

  static var allTests = [
    ("Test that initially content is empty", testThatInitiallyContentIsEmpty),
    ("Test that system title is processed correctly", testThatSystemTitleIsProcessedCorrectly),
    ("Test that custom title is processed correctly", testThatCustomTitleIsProcessedCorrectly),
    ("Test that mixed title is processed correctly", testThatMixedTitleProcessedCorrectly),
    ("Test that dynamically changed custom title is processed correctly", testThatDynamicCustomTitleProcessedCorrectly),
  ]
}


private class SystemViewController: UIViewController {
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  init(title: String) {
    super.init(nibName: nil, bundle: nil)
    
    self.title = title
  }
}


private class CustomViewController: UIViewController, NavigationBarContentProvider {

  @RxUiInput(.empty) var contentSetter: AnyObserver<NavigationBarContent>
  
  @RxOutput(.empty) var content: Observable<NavigationBarContent>
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  private let disposeBag = DisposeBag()
  
  init(content: Observable<NavigationBarContent>) {
    super.init(nibName: nil, bundle: nil)
    
    _contentSetter.bind(to: _content).disposed(by: disposeBag)
    
    content.bind(to: _content).disposed(by: disposeBag)
  }

  var navigationBarContent: Driver<NavigationBarContent> {
    content.asDriver(onErrorJustReturn: .title(.string("Caramba")))
  }
}
