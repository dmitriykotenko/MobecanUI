//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


/// Простой аналог тэйбл-вью для случая, когда надо показать совсем мало элементов.
///
/// Отличия:
///
/// — в нём нет скролла
///
/// — когда в нём мало элементов, уменьшает свою высоту, а не растягивается на весь экран
///
/// — не переиспользует ячейки
///
/// — при обновлении списка данных полностью перезагружает ячейки и из-за этого как будто моргает
/// (это будет исправлено в следующих версиях)
open class ListView<Element, View: EventfulView>: UIView, DataView, EventfulView {

  public typealias Value = [Element]
  public typealias ViewEvent = View.ViewEvent

  @RxUiInput(nil) open var value: AnyObserver<[Element]?>
  @RxOutput open var viewEvents: Observable<View.ViewEvent>

  private let createView: (Element) -> View

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(createView: @escaping (Element) -> View) {
    self.createView = createView

    super.init(frame: .zero)

    _value
      .subscribe(onNext: { [weak self] in self?.displayElements($0 ?? []) })
      .disposed(by: disposeBag)
  }

  private func displayElements(_ elements: [Element]) {
    removeAllSubviews()

    let elementViews = elements.map { createView($0) }

    elementViews.forEach {
      $0.viewEvents.bind(to: _viewEvents).disposed(by: disposeBag)
    }

    putSingleSubview(.vstack(elementViews))
  }
}
