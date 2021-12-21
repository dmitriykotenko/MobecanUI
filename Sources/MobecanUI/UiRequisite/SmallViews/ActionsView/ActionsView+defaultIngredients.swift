//  Copyright © 2021 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public extension ActionsViewCheckboxer {

  static func defaultCheckboxer() -> ActionsViewCheckboxer {
    .init(
      initCheckmarkView: {
        .init(
          selectedView: .circle(radius: 10).backgroundColor(.systemBlue),
          notSelectedView: .circle(radius: 10).backgroundColor(.systemGray),
          horizontalInset: 0
        )
      },
      checkmarkPlacement: .init(
        horizontal: .leading,
        vertical: .center
      )
    )
  }
}


public extension ActionsViewErrorDisplayer {

  static func defaultErrorDisplayer() -> ActionsViewErrorDisplayer {
    .init(
      initLabel: { UILabel().textStyle(.color(.systemRed)) },
      labelInsets: .zero,
      displayError: { .init(errorText: $0, backgroundColor: nil) }
    )
  }
}


public extension ActionsViewSwiper {

  static func defaultSwiper() -> ActionsViewSwiper {
    .init(
      possibleButtonsAndActions: [],
      trailingView: { _ in .spacer(width: 0) },
      animationDuration: 250.milliseconds
    )
  }
}
