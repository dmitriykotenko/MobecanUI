// Copyright © 2022 Mobecan. All rights reserved.


public func zip<A, B, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>
) -> Result<(A, B), Failure> {
  switch (resultA, resultB) {
  case (.success(let a), .success(let b)):
    return .success((a, b))
  default:
    return .failure(
      [resultA.asError, resultB.asError].filterNil()[0]
    )
  }
}


public func zip<A, B, C, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>
) -> Result<(A, B, C), Failure> {
  switch (resultA, resultB, resultC) {
  case (.success(let a), .success(let b), .success(let c)):
    return .success((a, b, c))
  default:
    return .failure(
      [resultA.asError, resultB.asError, resultC.asError].filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>
) -> Result<(A, B, C, D), Failure> {
  switch (resultA, resultB, resultC, resultD) {
  case (.success(let a), .success(let b), .success(let c), .success(let d)):
    return .success((a, b, c, d))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>
) -> Result<(A, B, C, D, E), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE) {
  case (.success(let a), .success(let b), .success(let c), .success(let d), .success(let e)):
    return .success((a, b, c, d, e))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>
) -> Result<(A, B, C, D, E, F), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f)):
    return .success((a, b, c, d, e, f))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, G, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>,
  _ resultG: Result<G, Failure>
) -> Result<(A, B, C, D, E, F, G), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF, resultG) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f),
        .success(let g)):
    return .success((a, b, c, d, e, f, g))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError,
        resultG.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, G, H, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>,
  _ resultG: Result<G, Failure>,
  _ resultH: Result<H, Failure>
) -> Result<(A, B, C, D, E, F, G, H), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f),
        .success(let g), .success(let h)):
    return .success((a, b, c, d, e, f, g, h))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError,
        resultG.asError, resultH.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, G, H, I, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>,
  _ resultG: Result<G, Failure>,
  _ resultH: Result<H, Failure>,
  _ resultI: Result<I, Failure>
) -> Result<(A, B, C, D, E, F, G, H, I), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH, resultI) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f),
        .success(let g), .success(let h), .success(let i)):
    return .success((a, b, c, d, e, f, g, h, i))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError,
        resultG.asError, resultH.asError, resultI.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, G, H, I, J, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>,
  _ resultG: Result<G, Failure>,
  _ resultH: Result<H, Failure>,
  _ resultI: Result<I, Failure>,
  _ resultJ: Result<J, Failure>
) -> Result<(A, B, C, D, E, F, G, H, I, J), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH, resultI, resultJ) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f),
        .success(let g), .success(let h), .success(let i),
        .success(let j)):
    return .success((a, b, c, d, e, f, g, h, i, j))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError,
        resultG.asError, resultH.asError, resultI.asError,
        resultJ.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, G, H, I, J, K, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>,
  _ resultG: Result<G, Failure>,
  _ resultH: Result<H, Failure>,
  _ resultI: Result<I, Failure>,
  _ resultJ: Result<J, Failure>,
  _ resultK: Result<K, Failure>
) -> Result<(A, B, C, D, E, F, G, H, I, J, K), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH, resultI, resultJ, resultK) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f),
        .success(let g), .success(let h), .success(let i),
        .success(let j), .success(let k)):
    return .success((a, b, c, d, e, f, g, h, i, j, k))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError,
        resultG.asError, resultH.asError, resultI.asError,
        resultJ.asError, resultK.asError
      ]
      .filterNil()[0]
    )
  }
}


public func zip<A, B, C, D, E, F, G, H, I, J, K, L, Failure>(
  _ resultA: Result<A, Failure>,
  _ resultB: Result<B, Failure>,
  _ resultC: Result<C, Failure>,
  _ resultD: Result<D, Failure>,
  _ resultE: Result<E, Failure>,
  _ resultF: Result<F, Failure>,
  _ resultG: Result<G, Failure>,
  _ resultH: Result<H, Failure>,
  _ resultI: Result<I, Failure>,
  _ resultJ: Result<J, Failure>,
  _ resultK: Result<K, Failure>,
  _ resultL: Result<L, Failure>
) -> Result<(A, B, C, D, E, F, G, H, I, J, K, L), Failure> {
  switch (resultA, resultB, resultC, resultD, resultE, resultF, resultG, resultH, resultI, resultJ, resultK, resultL) {
  case (.success(let a), .success(let b), .success(let c),
        .success(let d), .success(let e), .success(let f),
        .success(let g), .success(let h), .success(let i),
        .success(let j), .success(let k), .success(let l)):
    return .success((a, b, c, d, e, f, g, h, i, j, k, l))
  default:
    return .failure(
      [
        resultA.asError, resultB.asError, resultC.asError,
        resultD.asError, resultE.asError, resultF.asError,
        resultG.asError, resultH.asError, resultI.asError,
        resultJ.asError, resultK.asError, resultL.asError
      ]
      .filterNil()[0]
    )
  }
}
