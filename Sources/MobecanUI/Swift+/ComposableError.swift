// Copyright © 2023 Mobecan. All rights reserved.

import Foundation
import NonEmpty
import SwiftDateTime


public protocol ComposableError: Error {

  static func composed(from children: NonEmpty<[String: Self]>) -> Self
}
