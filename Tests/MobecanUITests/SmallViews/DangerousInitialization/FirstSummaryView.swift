import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class IntParagraphView: ParagraphView<Int> {

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  required init() {
    super.init(
      titleLabel: UILabel(),
      content: .init(
        bodyView: UIView(),
        body: .onNext { _ in }
      ),
      spacing: 0
    )
  }
}
