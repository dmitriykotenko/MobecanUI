// Copyright © 2020 Mobecan. All rights reserved.


/// Object that can be displayed in table view.
public protocol ViewRepresentable {
  
  associatedtype ContentView: EventfulView & DataView where ContentView.Value == Self
}
