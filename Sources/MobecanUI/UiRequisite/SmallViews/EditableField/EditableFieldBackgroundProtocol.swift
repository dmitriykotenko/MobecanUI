//  Copyright © 2020 Mobecan. All rights reserved.

import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public protocol EditableFieldBackgroundProtocol: UIView {

  typealias State = EditableFieldBackgroundState

  var state: AnyObserver<State> { get }
}


public enum EditableFieldBackgroundState: String, Equatable, Hashable, Codable {

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
