// Copyright © 2021 Mobecan. All rights reserved.


// Equatable and hashable version of Void, which is also open to other protocols' conformance.
public enum EquatableVoid: Int, Equatable, Hashable, Codable {

  case instance
}
