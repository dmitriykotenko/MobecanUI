//  Copyright © 2020 Mobecan. All rights reserved.

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
    
    view.addSingleSubview(
      .vstack([
        .safeAreaZstack(padding: titleLabelInsets, [titleLabel]),
        tableView
      ])
    )
  }

  open func setPresenter<Presenter: ListPresenterProtocol>(_ presenter: Presenter)
    where
    Presenter.Query == Query,
    Presenter.Element == Element,
    Presenter.ElementEvent == ElementEvent {
      
      presenter.title.drive(titleLabel.rx.text).disposed(by: disposeBag)

      tableViewDriver.map {
          presenter.sections
            .drive($0.sections)
            .disposed(by: disposeBag)
        
          $0.cellEvents
            .bind(to: presenter.elementEvents)
            .disposed(by: disposeBag)
      }
  }
}
