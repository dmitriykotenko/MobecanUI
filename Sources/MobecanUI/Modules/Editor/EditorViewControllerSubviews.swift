// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditorViewControllerSubviews {
  
  public var editorView: UIView
  public var closeButton: UIButton?
  public var finalizeButtonContainer: LoadingButtonContainer
  public var initScrollView: () -> UIScrollView

  public init(editorView: UIView,
              closeButton: UIButton?,
              finalizeButtonContainer: LoadingButtonContainer,
              initScrollView: @escaping () -> UIScrollView) {
    self.editorView = editorView
    self.closeButton = closeButton
    self.finalizeButtonContainer = finalizeButtonContainer
    self.initScrollView = initScrollView
  }
}
