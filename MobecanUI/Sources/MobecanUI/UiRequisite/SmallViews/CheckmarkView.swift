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
              horizontalPadding: CGFloat,
              verticalPadding: CGFloat? = nil) {
    self.selectedView = selectedView
    self.notSelectedView = notSelectedView
    
    super.init(frame: .zero)

    addSubviews(
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding
    )
    
    _setIsSelected
      .subscribe(onNext: { [weak self] in
        self?.selectedView.isHidden = !$0
        self?.notSelectedView.isHidden = $0
      })
      .disposed(by: disposeBag)
    
    setIsSelected.onNext(isSelected)
  }
  
  private func addSubviews(horizontalPadding: CGFloat,
                           verticalPadding: CGFloat?) {
    addSingleSubview(
      mainSubview(verticalPadding: verticalPadding),
      insets: .horizontal(horizontalPadding)
    )
  }

  private func mainSubview(verticalPadding: CGFloat?) -> UIView {
    let stack = UIView.zstack([notSelectedView, selectedView])
    
    switch verticalPadding {
    case nil:
      return .centered(axis: [.vertical], stack)
    case let padding?:
      return .zstack(padding: .vertical(padding), [stack])
    }
  }
}
