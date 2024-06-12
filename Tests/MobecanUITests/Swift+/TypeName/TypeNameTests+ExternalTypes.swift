import XCTest

import SnapKit
import RxSwift
import SwiftDateTime

@testable import MobecanUI


final class TypeNameTests_ExternalType: TypeNameTester {

  func testSwiftDateTime() {
    check(
      type: SwiftDateTime.DateTime.self,
      expectedTypeName: .init(
        nonQualified: "DateTime",
        qualified: "SwiftDateTime.DateTime",
        mangled: areMangledNamesSupported ? "13SwiftDateTime0bC0V" : nil
      )
    )

    check(
      type: SwiftDateTime.DateTime.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testRxSwiftCompletable() {
    check(
      type: RxSwift.Completable.self,
      expectedTypeName: .init(
        nonQualified: "PrimitiveSequence<CompletableTrait, Never>",
        qualified: "RxSwift.PrimitiveSequence<RxSwift.CompletableTrait, Swift.Never>",
        mangled: areMangledNamesSupported ? "7RxSwift17PrimitiveSequenceVyAA16CompletableTraitOs5NeverOG" : nil
      )
    )

    check(
      type: RxSwift.Completable.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testRxSwiftObservable() {
    check(
      type: RxSwift.Observable<DayMonthYear>.self,
      expectedTypeName: .init(
        nonQualified: "Observable<DayMonthYear>",
        qualified: "RxSwift.Observable<SwiftDateTime.DayMonthYear>",
        mangled: areMangledNamesSupported ? "7RxSwift10ObservableCy0B8DateTime12DayMonthYearVG" : nil
      )
    )

    check(
      type: RxSwift.Observable<DayMonthYear>.self,
      shouldBeReconstructed: areMangledNamesSupported
    )
  }

  func testSnapKitConstraint() {
    check(
      type: SnapKit.Constraint.self,
      expectedTypeName: .init(
        nonQualified: "Constraint",
        qualified: "SnapKit.Constraint",
        mangled: areMangledNamesSupported ? "7SnapKit10ConstraintC" : nil
      )
    )

    check(
      type: SnapKit.Constraint.self,
      shouldBeReconstructed: true
    )
  }
}
