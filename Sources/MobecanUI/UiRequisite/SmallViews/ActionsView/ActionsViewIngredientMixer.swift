//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public protocol ActionsViewIngredientMixer {

  associatedtype ContentView: DataView & EventfulView
  associatedtype State
  associatedtype Event
  
  typealias Value = ContentView.Value
  
  func setup(contentView: ContentView,
             containerView: UIView) -> ActionsViewStructs.Ingredient<Value, State, Event>
}
