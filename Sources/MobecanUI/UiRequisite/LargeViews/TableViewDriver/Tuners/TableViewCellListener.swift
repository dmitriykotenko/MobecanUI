// Copyright © 2020 Mobecan. All rights reserved.

import RxSwift
import UIKit


class TableViewCellListener<Value, Event> {

  @RxOutput var events: Observable<Event>

  private var listenedCells: Set<UITableViewCell> = []
  
  private let disposeBag = DisposeBag()
  
  func listen(cell: UITableViewCell,
              events: Observable<Event>) {
    // Avoid multiple subscriptions to same cell
    guard !listenedCells.contains(cell) else { return }
    
    listenedCells.insert(cell)
    
    events.bind(to: _events).disposed(by: disposeBag)
  }
}
