//  Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import SwiftDateTime
import UIKit


/// Wraps any UIView, so it can be used inside UITableView.
public class WrapperCell<Value, MainSubview: EventfulView & DataView>: UITableViewCell
where MainSubview.Value == Value {
  
  public var viewEvents: Observable<MainSubview.ViewEvent> { mainSubview?.viewEvents ?? .never() }
  
  @RxUiInput(.empty) public var relativePosition: AnyObserver<RowRelativePosition>
  
  public var initMainSubview: () -> MainSubview = { MainSubview() }
  public var mainSubviewInsets: UIEdgeInsets = .zero

  private var mainSubview: MainSubview?
  
  public var bottomShadow: UIView?
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  override init(style: UITableViewCell.CellStyle,
                reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  private func initIfNeeded() {
    guard mainSubview == nil else { return }
    
    addMainSubview()
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    setupBottomShadow()
  }
  
  private func addMainSubview() {
    mainSubview = initMainSubview()
        
    mainSubview.map(contentView.addSubview)
    
    mainSubview?.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(mainSubviewInsets)
    }
  }
  
  public func displayValue(_ value: Value?) {
    initIfNeeded()
    
    mainSubview?.value.onNext(value)
  }
  
  private func setupBottomShadow() {
    bottomShadow.map(setupBottomShadow)
  }

  private func setupBottomShadow(_ bottomShadow: UIView) {
    let bottomShadowContainer = ClickThroughView().clipsToBounds(true)

    bottomShadowContainer.addSubview(bottomShadow)
    
    bottomShadow.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(bottomShadowContainer.snp.bottom)
    }

    contentView.addSubview(bottomShadowContainer)
    
    bottomShadowContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    _relativePosition
      .map { $0.isLastSection || !$0.isLastRow }
      .bind(to: bottomShadow.rx.isHidden)
      .disposed(by: disposeBag)
  }
}


extension WrapperCell: MarkableView where MainSubview: MarkableView {

  public var textToMark: AnyObserver<String?> {
    return mainSubview?.textToMark ?? .empty
  }
}


extension WrapperCell: TemporalView where MainSubview: TemporalView {
  
  public var clock: AnyObserver<Clock?> {
    return mainSubview?.clock ?? .empty
  }
}



extension AnyObserver {
  
  static var empty: AnyObserver<Element> {
    return AnyObserver { _ in }
  }
}
