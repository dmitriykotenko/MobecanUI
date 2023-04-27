// Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


open class EditorViewControllerLayout {

  private let privateSetup: (LayoutableView, EditorViewControllerSubviews) -> Void

  public init(_ setup: @escaping (LayoutableView, EditorViewControllerSubviews) -> Void) {
    self.privateSetup = setup
  }

  open func setup(parentView: LayoutableView,
                  subviews: EditorViewControllerSubviews) {
    privateSetup(parentView, subviews)
  }
  
  public static func finalizeButtonAtBottom(spacing: CGFloat) -> EditorViewControllerLayout {
    .init { parentView, subviews in
      parentView.layout = InsetLayout<UIView>.fromSingleSubview(
        ScrollableView(
          contentView: .vstack(spacing: spacing, [
            subviews.editorView,
            subviews.finalizeButtonContainer
          ]),
          scrollView: subviews.initScrollView
        )
      )
    }
  }
  
  public static func finalizeButtonInNavigationBar() -> EditorViewControllerLayout {
    .init { parentView, subviews in
      let contentView = subviews.editorView
      let finalizeButtonContainer = subviews.finalizeButtonContainer
      let initScrollView = subviews.initScrollView
      
      parentView.layout = InsetLayout<UIView>.fromSingleSubview(
        .zstack([
          ScrollableView(
            contentView: .vstack([
              .rxSpacer(finalizeButtonContainer),
              contentView
            ]),
            scrollView: initScrollView
          ),
          .safeAreaZstack([
            .topTrailing(finalizeButtonContainer).clickThrough()
          ])
          .clickThrough()
        ])
      )
    }
  }
}
