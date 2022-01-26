// Copyright © 2021 Mobecan. All rights reserved.

import UIKit


public enum StringTransformer {

  case plain((String?) -> String?)
  case attributed((NSAttributedString?) -> NSAttributedString?)
  case plainToAttributed((String?) -> NSAttributedString?)

  static let empty = plain { $0 }
  static let attributedEmpty = attributed { $0 }

  init(transform: @escaping (String?) -> String?) {
    self = .plain(transform)
  }
}
