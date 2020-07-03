//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public extension UITableView {
  
  typealias ElementCell<Element: ViewRepresentable> = WrapperCell<Element, Element.ContentView>

  func registerCell<Element: ViewRepresentable>(for elementType: Element.Type) {
    register(ElementCell<Element>.self)
  }
  
  func dequeueCell<Element: ViewRepresentable>(for elementType: Element.Type) -> ElementCell<Element> {
    dequeue(ElementCell<Element>.self)
  }
}
