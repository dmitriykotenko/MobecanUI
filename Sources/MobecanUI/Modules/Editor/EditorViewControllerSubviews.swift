// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public struct EditorViewControllerSubviews {
  
  public var editorView: UIView
  public var closeButton: UIButton?
  public var topTrailingView: UIView?
  public var finalizeButtonContainer: LoadingButtonContainer
  public var initScrollView: () -> UIScrollView

  public init(editorView: UIView,
              closeButton: UIButton?,
              topTrailingView: UIView? = nil,
              finalizeButtonContainer: LoadingButtonContainer,
              initScrollView: @escaping () -> UIScrollView) {
    self.editorView = editorView
    self.closeButton = closeButton
    self.topTrailingView = topTrailingView
    self.finalizeButtonContainer = finalizeButtonContainer
    self.initScrollView = initScrollView
  }
}
