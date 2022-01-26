// Copyright © 2020 Mobecan. All rights reserved.

import UIKit


public class PanStartPosition {
  
  open func isValid(for gesture: UIPanGestureRecognizer) -> Bool { true }
}


public extension PanStartPosition {
  
  static func above(_ anotherView: UIView,
                    inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.y <= frame.minY - inset }
  }
  
  static func notAbove(_ anotherView: UIView,
                       inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.y >= frame.minY - inset }
  }
  
  static func below(_ anotherView: UIView,
                    inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.y >= frame.maxY + inset }
  }
  
  static func notBelow(_ anotherView: UIView,
                       inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.y <= frame.maxY + inset }
  }
  
  static func toTheLeft(of anotherView: UIView,
                        inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.x <= frame.minX - inset }
  }
  
  static func notToTheLeft(of anotherView: UIView,
                           inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.x >= frame.minX - inset }
  }
  
  static func toTheRight(of anotherView: UIView,
                         inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.x >= frame.maxX + inset }
  }
  
  static func notToTheRight(of anotherView: UIView,
                            inset: CGFloat) -> PanStartPosition {
    predicate(anotherView) { frame, start in start.x <= frame.maxX + inset }
  }
  
  static func horizontallyInside(_ anotherView: UIView,
                                 insets: UIEdgeInsets) -> PanStartPosition {
    predicate(anotherView) { frame, start in
      frame.inset(by: insets.negated).containsHorizontally(point: start)
    }
  }
  
  static func horizontallyOutside(_ anotherView: UIView,
                                  insets: UIEdgeInsets) -> PanStartPosition {
    predicate(anotherView) { frame, start in
      !frame.inset(by: insets.negated).containsHorizontally(point: start)
    }
  }
  
  static func verticallyInside(_ anotherView: UIView,
                               insets: UIEdgeInsets) -> PanStartPosition {
    predicate(anotherView) { frame, start in
      frame.inset(by: insets.negated).containsVertically(point: start)
    }
  }
  
  static func verticallyOutside(_ anotherView: UIView,
                                insets: UIEdgeInsets) -> PanStartPosition {
    predicate(anotherView) { frame, start in
      !frame.inset(by: insets.negated).containsVertically(point: start)
    }
  }
  
  static func inside(_ anotherView: UIView,
                     insets: UIEdgeInsets) -> PanStartPosition {
    predicate(anotherView) { frame, start in
      frame.inset(by: insets.negated).contains(start)
    }
  }
  
  static func outside(_ anotherView: UIView,
                      insets: UIEdgeInsets) -> PanStartPosition {
    predicate(anotherView) { frame, start in
      !frame.inset(by: insets.negated).contains(start)
    }
  }
  
  private static func predicate(_ anotherView: UIView,
                                framePredicate: @escaping (CGRect, CGPoint) -> Bool) -> PanStartPosition {
    RelativePanStartPosition(
      anotherView,
      framePredicate: framePredicate
    )
  }
}


class FunctionalPanStartPosition: PanStartPosition {
  
  private let predicate: (UIPanGestureRecognizer) -> Bool
  
  init(predicate: @escaping (UIPanGestureRecognizer) -> Bool) {
    self.predicate = predicate
  }
  
  override func isValid(for gesture: UIPanGestureRecognizer) -> Bool {
    predicate(gesture)
  }
}


class RelativePanStartPosition: FunctionalPanStartPosition {
  
  convenience init(_ anotherView: UIView,
                   framePredicate: @escaping (CGRect, CGPoint) -> Bool) {
    self.init { gesture in
      guard
        let parentView = gesture.view,
        let start = gesture.startLocation()
        else { return true }
      
      let anotherViewFrame = parentView.convert(anotherView.bounds, from: anotherView)
      
      return framePredicate(anotherViewFrame, start)
    }
  }
}


extension UIPanGestureRecognizer {
  
  func startLocation() -> CGPoint? {
    view.map { location(in: $0) - translation(in: $0) }
  }
}


private extension CGRect {
  
  func containsHorizontally(point: CGPoint) -> Bool {
    (minX...maxX).contains(point.x)
  }
  
  func containsVertically(point: CGPoint) -> Bool {
    (minY...maxY).contains(point.y)
  }
}
