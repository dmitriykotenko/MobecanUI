// Copyright © 2025 Mobecan. All rights reserved.


public extension Array {

  subscript(safe index: Int) -> Element? {
    if index >= 0 && index < count { self[index] }
    else { nil }
  }
}
