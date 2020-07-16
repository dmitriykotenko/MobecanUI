//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditorViewControllerSubviews {
  
  public var editorView: UIView
  public var saveButtonContainer: LoadingButtonContainer
  public var initScrollView: (UIView) -> UIScrollView
  
  public init(editorView: UIView,
              saveButtonContainer: LoadingButtonContainer,
              initScrollView: @escaping (UIView) -> UIScrollView) {
    self.editorView = editorView
    self.saveButtonContainer = saveButtonContainer
    self.initScrollView = initScrollView
  }
}
