// Copyright © 2020 Mobecan. All rights reserved.

import Foundation


public extension Encodable {
  
  var jsonDescription: String {
    let description = try? String(data: JSONEncoder().encode(self), encoding: .utf8)
    
    return description ?? "\(Self.self)"
  }
}
