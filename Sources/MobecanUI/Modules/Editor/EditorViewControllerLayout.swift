//  Copyright © 2020 Mobecan. All rights reserved.

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
  
  public static func saveButtonAtBottom(spacing: CGFloat) -> EditorViewControllerLayout {
    .init { parentView, subviews in
      parentView.layout = InsetLayout<UIView>.fromSingleSubview(
        ScrollableView(
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
      
      parentView.layout = InsetLayout<UIView>.fromSingleSubview(
        .zstack([
          ScrollableView(
            contentView: .vstack([
              .rxSpacer(saveButtonContainer),
              contentView
            ]),
            scrollView: initScrollView
          ),
          .safeAreaZstack([
            .topTrailing(saveButtonContainer).clickThrough()
          ])
          .clickThrough()
        ])
      )
    }
  }
}
