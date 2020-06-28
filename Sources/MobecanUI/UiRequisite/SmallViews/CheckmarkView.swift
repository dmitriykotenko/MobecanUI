//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


public class CheckmarkView: UIView {

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
    
    super.init(frame: .zero)

    addSubviews(
      horizontalInset: horizontalInset,
      verticalInset: verticalInset
    )
    
    _setIsSelected
      .subscribe(onNext: { [weak self] in
        self?.selectedView.isHidden = !$0
        self?.notSelectedView.isHidden = $0
      })
      .disposed(by: disposeBag)
    
    setIsSelected.onNext(isSelected)
  }
  
  private func addSubviews(horizontalInset: CGFloat,
                           verticalInset: CGFloat?) {
    putSubview(
      mainSubview(verticalInset: verticalInset),
      insets: .horizontal(horizontalInset)
    )
  }

  private func mainSubview(verticalInset: CGFloat?) -> UIView {
    let stack = UIView.zstack([notSelectedView, selectedView])
    
    switch verticalInset {
    case nil:
      return .centered(axis: [.vertical], stack)
    case let inset?:
      return .zstack([stack], insets: .vertical(inset))
    }
  }
}
