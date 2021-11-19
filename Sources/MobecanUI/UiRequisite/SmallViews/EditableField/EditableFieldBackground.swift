//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public class EditableFieldBackground: LayoutableView {
  
  public enum State: String, Equatable, Hashable, Codable {
    case regular
    case disabled
    case focused
    case error
    
    init(isEnabled: Bool, isFocused: Bool, error: Error?) {
      if isEnabled {
        self = (error != nil) ? .error : isFocused ? .focused : .regular
      } else {
        self = .disabled
      }
    }
  }
  
  @RxUiInput public var state: AnyObserver<State>
  
  private let regularBackground: UIView
  private let disabledBackground: UIView
  private let focusedBackground: UIView
  private let errorBackground: UIView
  
  private lazy var allBackgrounds = [regularBackground, disabledBackground, focusedBackground, errorBackground]

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }

  public init(regular: UIView, disabled: UIView, focused: UIView, error: UIView) {
    regularBackground = regular
    disabledBackground = disabled
    focusedBackground = focused
    errorBackground = error
    
    super.init()
    
    setupLayout()
    setupVisibleSubview()
  }
  
  private func setupLayout() {
    layout = UIView.zstack(allBackgrounds).asLayout
  }
  
  private func setupVisibleSubview() {
    let visibleBackground = _state.map { [weak self] in self?.visibleSubview(state: $0) }
    
    allBackgrounds.forEach { view in
      disposeBag {
        visibleBackground.isNotEqual(to: view) ==> view.rx.isHidden
      }
    }
  }
  
  private func visibleSubview(state: State) -> UIView {
    switch state {
    case .regular:
      return regularBackground
    case .disabled:
      return disabledBackground
    case .focused:
      return focusedBackground
    case .error:
      return errorBackground
    }
  }
}
