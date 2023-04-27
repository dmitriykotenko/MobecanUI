// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditorViewControllerSubviews {
  
  public var editorView: UIView
  public var finalizeButtonContainer: LoadingButtonContainer
  public var initScrollView: () -> UIScrollView
  
  public init(editorView: UIView,
              finalizeButtonContainer: LoadingButtonContainer,
              initScrollView: @escaping () -> UIScrollView) {
    self.editorView = editorView
    self.finalizeButtonContainer = finalizeButtonContainer
    self.initScrollView = initScrollView
  }
}
