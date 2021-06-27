//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


// swiftlint:disable nesting
public enum ActionsViewStructs {
  
  public enum SelectionState { case notSelectable, isSelected(Bool) }

  public enum SideAction { case delete }

  public struct Ingredient<Value, State, Event> {
    let containerView: UIView
    let value: AnyObserver<Value?>
    let state: AnyObserver<State>
    let events: Observable<Event>
  }
  
  public struct CheckmarkPlacement {
    
    public enum Horizontal {
      case leading
      case trailing
    }
    
    public enum Vertical {
      case center
      case contentViewFirstBaseline(offset: CGFloat)
    }
    
    public let horizontal: Horizontal
    public let vertical: Vertical
    
    public init(horizontal: Horizontal,
                vertical: Vertical) {
      self.horizontal = horizontal
      self.vertical = vertical
    }
  }

  public struct IngredientsState {
    
    public let selectionState: SelectionState
    public let errorText: String?
    public let sideActions: [SideAction]
    
    public init(selectionState: SelectionState = .notSelectable,
                errorText: String? = nil,
                sideActions: [SideAction] = []) {
      self.selectionState = selectionState
      self.errorText = errorText
      self.sideActions = sideActions
    }
  }

  public struct ErrorContainerState {

    public var errorText: String?
    public var backgroundColor: UIColor?

    public init(errorText: String? = nil,
                backgroundColor: UIColor? = nil) {
      self.errorText = errorText
      self.backgroundColor = backgroundColor
    }
  }
}
