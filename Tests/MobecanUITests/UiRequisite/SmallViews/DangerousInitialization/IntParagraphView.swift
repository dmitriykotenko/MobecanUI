import XCTest

import RxSwift
import RxTest

@testable import MobecanUI


class IntParagraphView: ParagraphView<Int, Never> {

  required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  required init() {
    super.init(
      titleLabel: UILabel(),
      content: .init(
        bodyView: UIView(),
        body: .empty
      ),
      spacing: 0
    )
  }
}
