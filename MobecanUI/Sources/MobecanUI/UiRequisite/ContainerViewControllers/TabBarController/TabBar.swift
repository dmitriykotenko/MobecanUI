//  Copyright © 2020 Mobecan. All rights reserved.


import RxSwift
import RxCocoa
import SnapKit
import UIKit


public class TabBar: UIView {

  public var visibleTabs: AnyObserver<[Tab]> { radioButton.visibleElements }
  public var selectTab: AnyObserver<Tab?> { radioButton.selectElement }

  public var selectedTab: Driver<Tab?> { radioButton.selectedElement }
  public var tabTap: Signal<Tab> { radioButton.userDidSelectElement.filterNil() }
  
  public let contentHeight: CGFloat

  private let backgroundView: UIView

  private let radioButton: RadioButton<Tab>
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(tabs: [Tab],
              backgroundView: UIView,
              initTabButton: @escaping (String?, UIImage?) -> TabButton,
              contentHeight: CGFloat,
              bottomInset: CGFloat) {
    self.backgroundView = backgroundView
    self.contentHeight = contentHeight
    
    radioButton = RadioButton(
      visibleElements: tabs,
      createButton: { initTabButton($0.title, $0.icon) }
    )

    super.init(frame: .zero)
   
    _ = height(contentHeight + bottomInset)
    
    addSubviews()
  }
  
  private func addSubviews() {
    addSubview(backgroundView)
    
    backgroundView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.greaterThanOrEqualToSuperview()
    }
    
    addSubview(radioButton)
    
    radioButton.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentHeight)
    }
  }
}
