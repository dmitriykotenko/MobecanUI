// Copyright © 2020 Mobecan. All rights reserved.

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

  /// Bottom-right counterpart of UIScrollView.contentOffset property.
  ///
  /// Horizontal and vertical distance
  /// between table view's visible area bottom-right corner and table view content's bottom-right corner.
  public var oppositeContentOffset: Observable<CGPoint> { oppositeContentOffsetTracker.value }

  private let tableView: UITableView
  
  private let stickerTuner: TableViewStickerTuner<Header, Sticker, StickerEvent>
  private let stickerListener: TableViewStickerListener<Header, StickerEvent>
  private let cellTuner: TableViewCellTuner<Element, CellEvent>
  private let cellListener: TableViewCellListener<Element, CellEvent>
  private let spacing: CGFloat?

  private let shaker: TableViewShaker

  @RxOutput private var adjustedContentInsetDidChange: Observable<Void>

  private lazy var oppositeContentOffsetTracker = RxScrollViewOppositeContentOffset(
    scrollView: tableView,
    adjustedContentInsetDidChange: adjustedContentInsetDidChange
  )
  
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
    disposeBag {
      _sections ==> { [weak self] in self?.sectionsSnapshot = $0 }

      _sections ==> { [weak self] in
        self?.sectionLengthsSnapshot = $0.map { $0.elements.count }
      }

      _shakes ==> { [weak self] in self?.shaker.performShakes($0) }
    }
    
    if automaticReloading {
      disposeBag {
        shakes <== _sections.map { _ in [.reloadData] }
      }
    }
  }
  
  private func setupInteractionWithKeyboard() {
    disposeBag {
      RxKeyboard.instance.visibleHeight
        .asObservable()
        .withLatestFrom(_focusedIndexPath) { (keyboardHeight: $0, focusedIndexPath: $1) }
        ==> { [weak self] (keyboardHeight, focusedIndexPath) in
          self.map {
            // 1. Fix table view's bottom content inset.
            var newContentInset = $0.tableView.contentInset
            newContentInset.bottom = keyboardHeight + 35
            $0.tableView.contentInset = newContentInset

            // 2. Keep focused element visible.
            $0.keepFocusedIndexPathVisible(focusedIndexPath: focusedIndexPath)
          }
        }
    }
  }
  
  private func keepFocusedIndexPathVisible(focusedIndexPath: IndexPath?) {
    focusedIndexPath.map {
      tableView.scrollToRow(at: $0, at: .top, animated: true)
    }
  }

  // MARK: - Scroll View Delegate

  public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    _adjustedContentInsetDidChange.onNext(())
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
      section(sectionIndex).header,
      relativePosition: .init(section: sectionIndex, of: sectionsSnapshot.count)
    )
  }
  
  public func tableView(_ tableView: UITableView,
                        viewForFooterInSection section: Int) -> UIView? {
    footerView()
  }
  
  private func footerView() -> UIView? {
    spacing.map { UIView.spacer(height: $0) }
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
