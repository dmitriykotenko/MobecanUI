//  Copyright © 2020 Mobecan. All rights reserved.

import RxKeyboard
import RxSwift
import UIKit


open class TableViewDriver<Header, Element, StickerEvent, CellEvent, Sticker>: NSObject,
  UITableViewDataSource, UITableViewDelegate
where
  Sticker: UITableViewHeaderFooterView & HeightAwareView,
  Sticker.Value == Header {

  public typealias Section = TableViewSection<Header, Element>
  
  public typealias CellAndEvents =
    (UITableView, Element, RowRelativePosition) -> (UITableViewCell, Observable<CellEvent>)

  @RxUiInput([]) public var sections: AnyObserver<[Section]>
  @RxUiInput public var shakes: AnyObserver<[TableViewShake]>
  @RxUiInput(nil) public var focusedIndexPath: AnyObserver<IndexPath?>

  public var cellEvents: Observable<CellEvent> { cellListener.events }
  public var stickerEvents: Observable<StickerEvent> { stickerListener.events }

  private let tableView: UITableView
  
  private let stickerTuner: TableViewStickerTuner<Header, Sticker, StickerEvent>
  private let stickerListener: TableViewStickerListener<Header, StickerEvent>
  private let cellTuner: TableViewCellTuner<Element, CellEvent>
  private let cellListener: TableViewCellListener<Element, CellEvent>
  private let spacing: CGFloat?

  private let shaker: TableViewShaker
  
  private let disposeBag = DisposeBag()

  public init(tableView: UITableView,
              displayHeader: ((Header, Sticker, SectionRelativePosition) -> Void)? = nil,
              stickerEvents: ((Sticker) -> Observable<StickerEvent>)? = nil,
              spacing: CGFloat,
              registerCells: @escaping (UITableView) -> Void,
              cellAndEvents: @escaping CellAndEvents,
              automaticReloading: Bool = true) {
    self.tableView = tableView
    self.spacing = spacing

    self.cellTuner = TableViewCellTuner(
      tableView: tableView,
      registerCells: registerCells,
      cellAndEvents: cellAndEvents
    )
    
    self.cellListener = TableViewCellListener()

    self.stickerTuner = TableViewStickerTuner(
      tableView: tableView,
      displayHeader: displayHeader,
      stickerEvents: stickerEvents
    )
    
    self.stickerListener = TableViewStickerListener()
    
    self.shaker = TableViewShaker(tableView)
    
    super.init()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    setupDataReloading(automaticReloading: automaticReloading)
    setupInteractionWithKeyboard()
  }
  
  private func setupDataReloading(automaticReloading: Bool) {
    _sections
      .subscribe(onNext: { [weak self] in self?.sectionsSnapshot = $0 })
      .disposed(by: disposeBag)

    _sections
      .subscribe(onNext: { [weak self] in self?.sectionLengthsSnapshot = $0.map { $0.elements.count } })
      .disposed(by: disposeBag)

    _shakes
      .subscribe(onNext: { [weak self] in self?.shaker.performShakes($0) })
      .disposed(by: disposeBag)
    
    if automaticReloading {
      _sections.map { _ in [.reloadData] }
        .bind(to: shakes)
        .disposed(by: disposeBag)
    }
  }
  
  private func setupInteractionWithKeyboard() {
    RxKeyboard.instance.visibleHeight
      .asObservable()
      .withLatestFrom(_focusedIndexPath) { (keyboardHeight: $0, focusedIndexPath: $1) }
      .subscribe(onNext: { [weak self] (keyboardHeight, focusedIndexPath) in
        self.map {
          // 1. Fix table view's bottom content inset.
          var newContentInset = $0.tableView.contentInset
          newContentInset.bottom = keyboardHeight + 35
          $0.tableView.contentInset = newContentInset
          
          // 2. Keep focused element visible.
          $0.keepFocusedIndexPathVisible(focusedIndexPath: focusedIndexPath)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func keepFocusedIndexPathVisible(focusedIndexPath: IndexPath?) {
    focusedIndexPath.map {
      tableView.scrollToRow(at: $0, at: .top, animated: true)
    }
  }

  // MARK: - Table View Data Source and Delegate
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    sectionsSnapshot.count
  }
  
  public func tableView(_ tableView: UITableView,
                        viewForHeaderInSection sectionIndex: Int) -> UIView? {
    let sticker = stickerTuner.sticker(
      header: section(sectionIndex).header,
      relativePosition: .init(section: sectionIndex, of: sectionsSnapshot.count)
    )
    
    sticker.map {
      let events = stickerTuner.events(sticker: $0) ?? .never()
      
      stickerListener.listen(sticker: $0, events: events)
    }
    
    return sticker
  }
  
  public func tableView(_ tableView: UITableView,
                        heightForHeaderInSection sectionIndex: Int) -> CGFloat {
    stickerTuner.heightForHeader(
      section(sectionIndex).header
    )
  }
  
  public func tableView(_ tableView: UITableView,
                        viewForFooterInSection section: Int) -> UIView? {
    footerView()
  }
  
  private func footerView() -> UIView? {
    spacing.map { UIView().height($0) }
  }
  
  public func tableView(_ tableView: UITableView,
                        heightForFooterInSection section: Int) -> CGFloat {
    spacing ?? 0
  }
  
  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection sectionIndex: Int) -> Int {
    section(sectionIndex).elements.count
  }
  
  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let (cell, events) = cellTuner.cellAndEvents(
      element: element(indexPath),
      relativePosition: .init(indexPath: indexPath, of: sectionLengthsSnapshot)
    )
    
    cellListener.listen(cell: cell, events: events)
    
    return cell
  }
  
  private func element(_ indexPath: IndexPath) -> Element {
    section(indexPath.section).elements[indexPath.row]
  }
  
  private func section(_ sectionIndex: Int) -> Section {
    sectionsSnapshot[sectionIndex]
  }
  
  private var sectionsSnapshot: [Section] = []
  private var sectionLengthsSnapshot: [Int] = []
}
