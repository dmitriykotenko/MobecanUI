//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SnapKit
import UIKit


public class TranslationView: UIView {

  @RxUiInput(.zero) public var translation: AnyObserver<CGPoint>

  private var contentLeft: Constraint?
  private var contentTop: Constraint?
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(_ contentView: UIView) {
    super.init(frame: .zero)
    
    addSubview(contentView)
    
    contentView.snp.makeConstraints {
      $0.width.height.equalToSuperview()

      contentLeft = $0.left.equalToSuperview().constraint
      contentTop = $0.top.equalToSuperview().constraint
    }
    
    _translation
      .subscribe(onNext: { [weak self] in
        self?.contentLeft?.update(offset: $0.x)
        self?.contentTop?.update(offset: $0.y)
      })
      .disposed(by: disposeBag)
  }
}
