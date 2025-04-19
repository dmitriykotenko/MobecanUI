import XCTest

import LayoutKit
import RxSwift
import RxTest

@testable import MobecanUI


class TableViewDriverCrashTests: XCTestCase {

  func testEarlySettingOfContentInset() {
    let window = UIWindow(
      frame: .init(x: 0, y: 0, width: 390, height: 844)
    )

    let tableView = UITableView(frame: window.bounds)

    window.addSubview(tableView)

    let driver = SimpleTableViewDriver<EquatableVoid, EquatableVoid>(
      tableView: tableView,
      spacing: 0,
      automaticReloading: false
    )

    tableView.contentInset = .top(333)
  }
}


extension EquatableVoid: ViewRepresentable {
  public typealias ContentView = EquatableVoidContentView
}


public class EquatableVoidContentView: UIView, DataView, EventfulView {

  public var viewEvents: Observable<EquatableVoid> = .never()
  @RxUiInput public var value: AnyObserver<EquatableVoid?>
}
