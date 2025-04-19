// Copyright © 2020 Mobecan. All rights reserved.

import RxKeyboard
import RxSwift
import UIKit


open class TableViewDriver<
  Element,
  CellEvent,
  Header,
  TopStickerEvent,
  TopSticker,
  Footer,
  BottomStickerEvent,
  BottomSticker
>: NSObject,
  UITableViewDataSource, UITableViewDelegate
where
  TopSticker: UITableViewHeaderFooterView & HeightAwareView,
  TopSticker.Value == Header,
  BottomSticker: UITableViewHeaderFooterView & HeightAwareView,
  BottomSticker.Value == Footer {

  public typealias Section = TableViewSection<Header, Element, Footer>

  public typealias CellAndEvents =
    (UITableView, Element, RowRelativePosition) -> (UITableViewCell, Observable<CellEvent>)

  @RxUiInput([]) public var sections: AnyObserver<[Section]>
  @RxUiInput public var shakes: AnyObserver<[TableViewShake]>
  @RxUiInput(nil) public var focusedIndexPath: AnyObserver<IndexPath?>

  public var cellEvents: Observable<CellEvent> { cellListener.events }
  public var topStickerEvents: Observable<TopStickerEvent> { topStickerListener.events }
  public var bottomStickerEvents: Observable<BottomStickerEvent> { bottomStickerListener.events }

  /// Противоположность свойства UIScrollView.contentOffset:
  /// горизонтальное и вертикальное расстояние
  /// от правого нижнего угла видимой части тэйбл-вьюшного контента
  /// до правого нижнего угла всего контента.
  public var oppositeContentOffset: Observable<CGPoint> { oppositeContentOffsetTracker.value }

  private let tableView: UITableView
  
  private let topStickerTuner: TableViewTopStickerTuner<Header, TopSticker, TopStickerEvent>
  private let topStickerListener: TableViewStickerListener<Header, TopStickerEvent>

  private let bottomStickerTuner: TableViewBottomStickerTuner<Footer, BottomSticker, BottomStickerEvent>
  private let bottomStickerListener: TableViewStickerListener<Footer, BottomStickerEvent>

  private let cellTuner: TableViewCellTuner<Element, CellEvent>
  private let cellListener: TableViewCellListener<Element, CellEvent>

  private let shaker: TableViewShaker

  @RxOutput private var adjustedContentInsetDidChange: Observable<Void>

  private lazy var oppositeContentOffsetTracker = RxScrollViewOppositeContentOffset(
    scrollView: tableView,
    adjustedContentInsetDidChange: adjustedContentInsetDidChange
  )
  
  private let disposeBag = DisposeBag()

  public init(tableView: UITableView,
              displayHeader: ((Header, TopSticker, SectionRelativePosition) -> Void)? = nil,
              topStickerEvents: ((TopSticker) -> Observable<TopStickerEvent>)? = nil,
              displayFooter: ((Footer, BottomSticker, SectionRelativePosition) -> Void)? = nil,
              bottomStickerEvents: ((BottomSticker) -> Observable<BottomStickerEvent>)? = nil,
              registerCells: @escaping (UITableView) -> Void,
              cellAndEvents: @escaping CellAndEvents,
              automaticReloading: Bool = true) {
    self.tableView = tableView

    self.cellTuner = TableViewCellTuner(
      tableView: tableView,
      registerCells: registerCells,
      cellAndEvents: cellAndEvents
    )
    
    self.cellListener = TableViewCellListener()

    self.topStickerTuner = TableViewTopStickerTuner(
      tableView: tableView,
      displayHeader: displayHeader,
      stickerEvents: topStickerEvents
    )
    
    self.topStickerListener = TableViewStickerListener()

    self.bottomStickerTuner = TableViewBottomStickerTuner(
      tableView: tableView,
      displayFooter: displayFooter,
      stickerEvents: bottomStickerEvents
    )

    self.bottomStickerListener = TableViewStickerListener()

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
            // 1. Исправляем у тэйбл-вью нижний contentInset.
            var newContentInset = $0.tableView.contentInset
            newContentInset.bottom = keyboardHeight + 35
            $0.tableView.contentInset = newContentInset

            // 2. Скроллим, чтобы клавиатура не закрывала элемент, на котором сейчас фокус.
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
    guard sectionsSnapshot.isNotEmpty else { return nil }

    let sticker = topStickerTuner.sticker(
      header: section(sectionIndex).header,
      relativePosition: .init(section: sectionIndex, of: sectionsSnapshot.count)
    )
    
    sticker.map {
      let events = topStickerTuner.events(sticker: $0) ?? .never()
      
      topStickerListener.listen(sticker: $0, events: events)
    }
    
    return sticker
  }
  
  public func tableView(_ tableView: UITableView,
                        heightForHeaderInSection sectionIndex: Int) -> CGFloat {
    guard sectionsSnapshot.isNotEmpty else { return 0 }

    return topStickerTuner.heightForHeader(
      section(sectionIndex).header,
      relativePosition: .init(section: sectionIndex, of: sectionsSnapshot.count)
    )
  }

  public func tableView(_ tableView: UITableView,
                        viewForFooterInSection sectionIndex: Int) -> UIView? {
    guard sectionsSnapshot.isNotEmpty else { return nil }

    let sticker = bottomStickerTuner.sticker(
      footer: section(sectionIndex).footer,
      relativePosition: .init(section: sectionIndex, of: sectionsSnapshot.count)
    )

    sticker.map {
      let events = bottomStickerTuner.events(sticker: $0) ?? .never()

      bottomStickerListener.listen(sticker: $0, events: events)
    }

    return sticker
  }

  public func tableView(_ tableView: UITableView,
                        heightForFooterInSection sectionIndex: Int) -> CGFloat {
    guard sectionsSnapshot.isNotEmpty else { return 0 }

    return bottomStickerTuner.heightForFooter(
      section(sectionIndex).footer,
      relativePosition: .init(section: sectionIndex, of: sectionsSnapshot.count)
    )
  }

  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection sectionIndex: Int) -> Int {
    sectionsSnapshot.isEmpty ? 0 : section(sectionIndex).elements.count
  }
  
  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard sectionsSnapshot.isNotEmpty else { return UITableViewCell() }

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
