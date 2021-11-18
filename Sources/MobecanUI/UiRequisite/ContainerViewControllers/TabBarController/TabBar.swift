//  Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import RxSwift
import RxCocoa
import SnapKit
import UIKit


public class TabBar: LayoutableView {

  public var visibleTabs: AnyObserver<[Tab]> { radioButton.visibleElements }
  public var selectTab: AnyObserver<Tab?> { radioButton.selectElement }

  public var selectedTab: Driver<Tab?> { radioButton.selectedElement }
  public var tabTap: Signal<Tab> { radioButton.userDidSelectElement.filterNil() }

  private let radioButton: RadioButton<Tab>
  private let backgroundView: UIView
  
  public let contentHeight: CGFloat

  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(tabs: [Tab],
              backgroundView: UIView,
              initTabButton: @escaping (String?, UIImage?) -> TabButton,
              contentHeight: CGFloat) {
    self.backgroundView = backgroundView
    self.contentHeight = contentHeight
    
    radioButton = RadioButton(
      visibleElements: tabs,
      createButton: { initTabButton($0.title, $0.icon) }
    )

    super.init()
    
    setupLayout(contentHeight: contentHeight)
  }
  
  private func setupLayout(contentHeight: CGFloat) {
    layout =
      .fromView(
        .zstack([
          backgroundView,
          .top(radioButton)
        ])
      )
      .with(height: contentHeight)
  }
}
