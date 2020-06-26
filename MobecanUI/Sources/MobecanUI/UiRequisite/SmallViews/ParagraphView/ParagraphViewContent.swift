//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct ParagraphViewContent<Value> {

  public var bodyView: UIView
  public var body: AnyObserver<Value?>
  
  public init(bodyView: UIView,
              body: AnyObserver<Value?>) {
    self.bodyView = bodyView
    self.body = body
  }
  
  public init<BodyView: DataView>(_ bodyView: BodyView) where BodyView.Value == Value {
    self.bodyView = bodyView
    self.body = bodyView.value
  }

  public static func dataView<BodyView: DataView>(_ bodyView: BodyView) -> ParagraphViewContent<Value>
    where BodyView.Value == Value {
    
      return ParagraphViewContent(bodyView: bodyView, body: bodyView.value)
  }
}


extension ParagraphViewContent where Value == String {
  
  public static func plainText(label: UILabel) -> ParagraphViewContent<String> {
    return ParagraphViewContent(
      bodyView: label,
      body: label.rx.text.asObserver()
    )
  }
}
