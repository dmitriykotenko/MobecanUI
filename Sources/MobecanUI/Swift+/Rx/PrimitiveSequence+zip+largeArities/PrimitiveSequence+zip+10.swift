// Copyright © 2024 Mobecan. All rights reserved.

import RxSwift


extension PrimitiveSequenceType where Trait == SingleTrait {

  /**
   Merges the specified observable sequences into one observable sequence by using the selector function whenever all of the observable sequences have produced an element at a corresponding index.

   - seealso: [zip operator on reactivex.io](http://reactivex.io/documentation/operators/zip.html)

   - parameter resultSelector: Function to invoke for each series of elements at corresponding indexes in the sources.
   - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
   */
  public static func zip<E1, E2, E3, E4, E5, E6, E7, E8, E9, E10>(
    _ source1: PrimitiveSequence<Trait, E1>,
    _ source2: PrimitiveSequence<Trait, E2>,
    _ source3: PrimitiveSequence<Trait, E3>,
    _ source4: PrimitiveSequence<Trait, E4>,
    _ source5: PrimitiveSequence<Trait, E5>,
    _ source6: PrimitiveSequence<Trait, E6>,
    _ source7: PrimitiveSequence<Trait, E7>,
    _ source8: PrimitiveSequence<Trait, E8>,
    _ source9: PrimitiveSequence<Trait, E9>,
    _ source10: PrimitiveSequence<Trait, E10>,
    resultSelector: @escaping (E1, E2, E3, E4, E5, E6, E7, E8, E9, E10) throws -> Element)
  -> PrimitiveSequence<Trait, Element> {
    Single.zip(
      Single<Any>.zip(source1, source2, source3),
      Single<Any>.zip(source4, source5, source6),
      Single<Any>.zip(source7, source8, source9),
      source10
    ) {
      try resultSelector(
        $0.0, $0.1, $0.2,
        $1.0, $1.1, $1.2,
        $2.0, $2.1, $2.2,
        $3
      )
    }
  }
}

extension PrimitiveSequenceType where Element == Any, Trait == SingleTrait {

  /**
   Merges the specified observable sequences into one observable sequence of tuples whenever all of the observable sequences have produced an element at a corresponding index.

   - seealso: [zip operator on reactivex.io](http://reactivex.io/documentation/operators/zip.html)

   - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
   */
  public static func zip<E1, E2, E3, E4, E5, E6, E7, E8, E9, E10>(
    _ source1: PrimitiveSequence<Trait, E1>,
    _ source2: PrimitiveSequence<Trait, E2>,
    _ source3: PrimitiveSequence<Trait, E3>,
    _ source4: PrimitiveSequence<Trait, E4>,
    _ source5: PrimitiveSequence<Trait, E5>,
    _ source6: PrimitiveSequence<Trait, E6>,
    _ source7: PrimitiveSequence<Trait, E7>,
    _ source8: PrimitiveSequence<Trait, E8>,
    _ source9: PrimitiveSequence<Trait, E9>,
    _ source10: PrimitiveSequence<Trait, E10>
  ) -> PrimitiveSequence<Trait, (E1, E2, E3, E4, E5, E6, E7, E8, E9, E10)> {
    Single.zip(
      Single<Any>.zip(source1, source2, source3),
      Single<Any>.zip(source4, source5, source6),
      Single<Any>.zip(source7, source8, source9),
      source10
    ) {
      (
        $0.0, $0.1, $0.2,
        $1.0, $1.1, $1.2,
        $2.0, $2.1, $2.2,
        $3
      )
    }
  }
}
