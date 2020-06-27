//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class TwoFaceView: ClickThroughView {
  
  @RxUiInput(0) public var borderTop: AnyObserver<CGFloat>
  
  private let topFace: UIView
  private let bottomFace: UIView
  
  private var topBackgroundHeight: Constraint?

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public convenience init(topColor: UIColor, bottomColor: UIColor) {
    self.init(
      topFace: ClickThroughView().backgroundColor(topColor),
      bottomFace: ClickThroughView().backgroundColor(bottomColor)
    )
  }

  public init(topFace: UIView, bottomFace: UIView) {
    self.topFace = topFace
    self.bottomFace = bottomFace
    
    super.init(frame: .zero)
    
    addSubviews()
    setupBorder()
  }
  
  private func addSubviews() {
    addSubview(topFace)
    
    topFace.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      topBackgroundHeight = $0.height.equalTo(0).constraint
    }
    
    addSubview(bottomFace)
    
    bottomFace.snp.makeConstraints {
      $0.top.equalTo(topFace.snp.bottom)
      $0.bottom.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupBorder() {
    _borderTop
      .subscribe(onNext: { [weak self] in self?.topBackgroundHeight?.update(offset: max($0, 0)) })
      .disposed(by: disposeBag)
  }
  
  public func bindTo(parentView: UIView,
                     scrollView: UIScrollView,
                     bottomView: UIView,
                     offset: CGFloat) {
    let framesListener = FramesListener(views: bottomView.andSuperviews(upTo: scrollView))
    
    Observable
      .merge(scrollView.rx.contentOffset.mapToVoid(), framesListener.framesChanged)
      .map { _ in bottomView.bounds }
      .map { parentView.convert($0, from: bottomView) }
      .map { $0.topSideCenter.y + offset }
      .bind(to: borderTop)
      .disposed(by: disposeBag)
  }
}
