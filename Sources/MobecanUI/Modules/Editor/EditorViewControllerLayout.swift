//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class EditorViewControllerLayout {

  private let privateSetup: (UIView, EditorViewControllerSubviews) -> Void

  public init(_ setup: @escaping (UIView, EditorViewControllerSubviews) -> Void) {
    self.privateSetup = setup
  }

  open func setup(parentView: UIView,
                  subviews: EditorViewControllerSubviews) {
    privateSetup(parentView, subviews)
  }
  
  public static func saveButtonAtBottom(spacing: CGFloat) -> EditorViewControllerLayout {
    .init { parentView, subviews in
      parentView.putSingleSubview(
        AutoshrinkingScrollableView(
          contentView: .vstack(spacing: spacing, [
            subviews.editorView,
            subviews.saveButtonContainer
          ]),
          scrollView: subviews.initScrollView
        )
      )
    }
  }
  
  public static func saveButtonInNavigationBar() -> EditorViewControllerLayout {
    .init { parentView, subviews in
      let contentView = subviews.editorView
      let saveButtonContainer = subviews.saveButtonContainer
      let initScrollView = subviews.initScrollView
      
      parentView.putSingleSubview(
        .zstack([
          AutoshrinkingScrollableView(
            contentView: .vstack([
              .rxSpacer(saveButtonContainer),
              contentView
            ]),
            scrollView: initScrollView
          ),
          ClickThroughView.safeAreaZstack([
            ClickThroughView.topTrailing(saveButtonContainer)
          ])
        ])
      )
    }
  }
}
