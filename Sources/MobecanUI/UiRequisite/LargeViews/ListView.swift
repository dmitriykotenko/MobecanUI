// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
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
open class ListView<Element, View: EventfulView>: LayoutableView, DataView, EventfulView {

  public typealias Value = [Element]
  public typealias ViewEvent = View.ViewEvent

  @RxUiInput(nil) open var value: AnyObserver<[Element]?>
  @RxUiInput(false) var hideIfEmpty: AnyObserver<Bool>
  @RxOutput open var viewEvents: Observable<View.ViewEvent>

  private let createView: (Element) -> View

  private let disposeBag = DisposeBag()

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(createView: @escaping (Element) -> View,
              hideIfEmpty: Bool = false) {
    self.createView = createView

    super.init()

    disposeBag {
      Observable.combineLatest(_value, _hideIfEmpty) ==> { [weak self] in
        self?.displayElements($0 ?? [], hideIfEmpty: $1)
      }
    }

    self.hideIfEmpty.onNext(hideIfEmpty)
  }

  private func displayElements(_ elements: [Element],
                               hideIfEmpty: Bool) {
    removeAllSubviews()

    isHidden = elements.isEmpty && hideIfEmpty

    let elementViews = elements.map { createView($0) }

    elementViews.forEach { view in
      disposeBag {
        view.viewEvents ==> _viewEvents
      }
    }

    layout = InsetLayout<UIView>.fromSingleSubview(
      .vstack(elementViews)
    )
  }

  @discardableResult
  open func hideIfEmpty(_ hideIfEmpty: Bool) -> Self {
    self.hideIfEmpty.onNext(hideIfEmpty)
    return self
  }
}
