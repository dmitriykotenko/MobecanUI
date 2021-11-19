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
    layout = .fromView(
      mainSubview(verticalInset: verticalInset)
    )
    .withInsets(.horizontal(horizontalInset))
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
