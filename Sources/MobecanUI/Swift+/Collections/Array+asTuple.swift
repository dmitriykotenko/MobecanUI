// Copyright © 2021 Mobecan. All rights reserved.


public extension Array {

  var asSingleElement: Element? {
    count == 1 ? self[0] : nil
  }

  var asPair: (Element, Element)? {
    count == 2 ? (self[0], self[1]) : nil
  }

  var asTriple: (Element, Element, Element)? {
    count == 3 ? (self[0], self[1], self[2]) : nil
  }

  var asTuple4: (Element, Element, Element, Element)? {
    count == 4 ? (self[0], self[1], self[2], self[3]) : nil
  }

  var asTuple5: (Element, Element, Element, Element, Element)? {
    count == 5 ? (self[0], self[1], self[2], self[3], self[4]) : nil
  }

  var asTuple6: (Element, Element, Element, Element, Element, Element)? {
    count == 6 ? (self[0], self[1], self[2], self[3], self[4], self[5]) : nil
  }

  var asTuple7: (Element, Element, Element, Element, Element, Element, Element)? {
    count == 7 ? (self[0], self[1], self[2], self[3], self[4], self[5], self[6]) : nil
  }

  var asTuple8: (Element, Element, Element, Element, Element, Element, Element, Element)? {
    count == 8 ? (self[0], self[1], self[2], self[3], self[4], self[5], self[6], self[7]) : nil
  }
}
