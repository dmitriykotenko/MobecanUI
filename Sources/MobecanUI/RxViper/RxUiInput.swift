// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift


/// Использует главный тред для прослушивания событий.
///
/// Принимает только события ``.next``, игнорирует события ``.completed`` и ``.error``.
@propertyWrapper
public class RxUiInput<Element>: ObservableType {
  
  private let publishRelay: PublishRelay<Element> = PublishRelay()
  private var behaviorRelay: BehaviorRelay<Element>?

  /// Отдельный ``MainScheduler`` нужен,
  /// потому что иногда ``MainScheduler.instance`` дёргает подписчиков не немедленно.
  private lazy var mainScheduler = MainScheduler()
  
  public init() {}
  
  public init(_ initialValue: Element) {
    behaviorRelay = BehaviorRelay(value: initialValue)
  }
  
  public var wrappedValue: AnyObserver<Element> {
    AnyObserver { [weak self] in
      switch $0 {
      case .next(let element):
        self?.behaviorRelay?.accept(element) ?? self?.publishRelay.accept(element)
      case .error, .completed:
        // Ничего не делаем. RxUiInput игнорирует сигналы о завершении или об ошибке.
        break
      }
    }
  }
  
  public func subscribe<Observer>(_ observer: Observer) -> Disposable
  where Observer: ObserverType, Element == Observer.Element {

    behaviorRelay?.observe(on: mainScheduler).subscribe(observer)
    ?? publishRelay.observe(on: mainScheduler).subscribe(observer)
  }
}
