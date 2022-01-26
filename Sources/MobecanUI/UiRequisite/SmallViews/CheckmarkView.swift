//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxSwift
import UIKit


public class CheckmarkView: LayoutableView {

  @RxUiInput(false) public var setIsSelected: AnyObserver<Bool>
  @RxOutput(false) public var isSelected: Observable<Bool>

  private let selectedView: UIView
  private let notSelectedView: UIView
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(selectedView: UIView,
              notSelectedView: UIView,
              isSelected: Bool = false,
              horizontalInset: CGFloat,
              verticalInset: CGFloat? = nil) {
    self.selectedView = selectedView
    self.notSelectedView = notSelectedView
    
    super.init()

    setupLayout(
      horizontalInset: horizontalInset,
      verticalInset: verticalInset
    )

    disposeBag {
      _setIsSelected ==> { [weak self] in
        self?.selectedView.isHidden = !$0
        self?.notSelectedView.isHidden = $0
        self?._isSelected.onNext($0)
      }
    }

    setIsSelected.onNext(isSelected)
  }
  
  private func setupLayout(horizontalInset: CGFloat,
                           verticalInset: CGFloat?) {
    let mainSubview = mainSubview(verticalInset: verticalInset)

    layout = InsetLayout<UIView>.fromSingleSubview(
      mainSubview,
      insets: .horizontal(horizontalInset)
    )

    setupContentHuggingPriority(mainSubview: mainSubview)
  }

  private func setupContentHuggingPriority(mainSubview: UIView) {
    setupContentHuggingPriority(mainSubview: mainSubview, axis: .horizontal)
    setupContentHuggingPriority(mainSubview: mainSubview, axis: .vertical)
  }

  private func setupContentHuggingPriority(mainSubview: UIView,
                                           axis: NSLayoutConstraint.Axis) {
    let maximum = max(
      selectedView.contentHuggingPriority(for: axis),
      notSelectedView.contentHuggingPriority(for: axis)
    )

    mainSubview.setContentHuggingPriority(maximum, for: axis)
    setContentHuggingPriority(maximum, for: axis)
  }

  private func mainSubview(verticalInset: CGFloat?) -> UIView {
    let stack = UIView.zstack([notSelectedView, selectedView])
    
    switch verticalInset {
    case nil:
      return .centeredVertically(stack)
    case let inset?:
      return .zstack([stack], insets: .vertical(inset))
    }
  }
}
