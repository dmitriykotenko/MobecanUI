// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class ListViewController<Query, Element, ElementEvent>: UIViewController {
  
  private let titleLabel: UILabel

  open var tableViewDriver: SimpleTableViewDriver<Element, ElementEvent>?
  
  public let tableView: UITableView
  
  private let tableViewHeader: UIView?
  
  private let titleLabelInsets: UIEdgeInsets
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(titleLabel: UILabel,
              titleLabelInsets: UIEdgeInsets,
              tableView: UITableView,
              tableViewHeader: UIView?) {
    self.titleLabel = titleLabel
    self.tableView = tableView
    self.tableViewHeader = tableViewHeader
    
    self.titleLabelInsets = titleLabelInsets
    
    super.init(nibName: nil, bundle: nil)
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    buildInterface()
  }

  private func buildInterface() {
    tableView.tableHeaderView = tableViewHeader
    
    view.putSubview(
      .vstack([
        .safeAreaZstack([titleLabel], insets: titleLabelInsets),
        tableView
      ])
    )
  }

  open func setPresenter<Presenter: ListPresenterProtocol>(_ presenter: Presenter)
  where
  Presenter.Query == Query,
  Presenter.Element == Element,
  Presenter.ElementEvent == ElementEvent {

    disposeBag {
      presenter.title ==> titleLabel.rx.text
    }

    tableViewDriver.map { driver in
      disposeBag {
        presenter.sections ==> driver.sections
        driver.cellEvents ==> presenter.elementEvents
      }
    }
  }
}
