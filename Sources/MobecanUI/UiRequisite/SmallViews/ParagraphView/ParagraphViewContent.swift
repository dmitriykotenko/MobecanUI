// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct ParagraphViewContent<Value, ViewEvent> {

  public var bodyView: UIView
  public var body: AnyObserver<Value?>
  public var bodyEvents: Observable<ViewEvent>
  
  public init(bodyView: UIView,
              body: AnyObserver<Value?>,
              bodyEvents: Observable<ViewEvent>) {
    self.bodyView = bodyView
    self.body = body
    self.bodyEvents = bodyEvents
  }

  public static func eventfulView<BodyView: DataView & EventfulView>(_ bodyView: BodyView)
  -> ParagraphViewContent<Value, ViewEvent>
  where BodyView.Value == Value, BodyView.ViewEvent == ViewEvent {

    ParagraphViewContent(
      bodyView: bodyView,
      body: bodyView.value,
      bodyEvents: bodyView.viewEvents
    )
  }
}

public extension ParagraphViewContent where ViewEvent == Never {

  public init(bodyView: UIView,
              body: AnyObserver<Value?>) {
    self.bodyView = bodyView
    self.body = body
    self.bodyEvents = .never()
  }

  public static func dataView<BodyView: DataView>(_ bodyView: BodyView) -> ParagraphViewContent<Value, Never>
  where BodyView.Value == Value {
      ParagraphViewContent(
        bodyView: bodyView,
        body: bodyView.value,
        bodyEvents: .never()
      )
  }
}


extension ParagraphViewContent where Value == String, ViewEvent == Never {
  
  public static func plainText(label: UILabel) -> ParagraphViewContent<String, Never> {
    ParagraphViewContent(
      bodyView: label,
      body: label.rx.text.asObserver()
    )
  }
}
