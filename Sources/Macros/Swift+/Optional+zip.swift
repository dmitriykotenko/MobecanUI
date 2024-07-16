// Copyright © 2021 Mobecan. All rights reserved.


public func zip<A, B>(_ maybeA: A?, _ maybeB: B?) -> (A, B)? {
  switch (maybeA, maybeB) {
  case (let a?, let b?):
    return (a, b)
  default:
    return nil
  }
}


public func zip<A, B, C>(_ maybeA: A?, _ maybeB: B?, _ maybeC: C?) -> (A, B, C)? {
  switch (maybeA, maybeB, maybeC) {
  case (let a?, let b?, let c?):
    return (a, b, c)
  default:
    return nil
  }
}


public func zip<A, B, C, D>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?
) -> (A, B, C, D)? {
  switch (maybeA, maybeB, maybeC, maybeD) {
  case (let a?, let b?, let c?, let d?):
    return (a, b, c, d)
  default:
    return nil
  }
}


public func zip<A, B, C, D, E>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?, _ maybeE: E?
) -> (A, B, C, D, E)? {
  switch (maybeA, maybeB, maybeC, maybeD, maybeE) {
  case (let a?, let b?, let c?, let d?, let e?):
    return (a, b, c, d, e)
  default:
    return nil
  }
}


public func zip<A, B, C, D, E, F>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?, _ maybeE: E?, _ maybeF: F?
) -> (A, B, C, D, E, F)? {
  switch (maybeA, maybeB, maybeC, maybeD, maybeE, maybeF) {
  case (let a?, let b?, let c?, let d?, let e?, let f?):
    return (a, b, c, d, e, f)
  default:
    return nil
  }
}


public func zip<A, B, C, D, E, F, G>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?, _ maybeE: E?, _ maybeF: F?,
  _ maybeG: G?
) -> (A, B, C, D, E, F, G)? {
  switch (maybeA, maybeB, maybeC, maybeD, maybeE, maybeF, maybeG) {
  case (let a?, let b?, let c?, let d?, let e?, let f?, let g?):
    return (a, b, c, d, e, f, g)
  default:
    return nil
  }
}


public func zip<A, B, C, D, E, F, G, H>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?, _ maybeE: E?, _ maybeF: F?,
  _ maybeG: G?, _ maybeH: H?
) -> (A, B, C, D, E, F, G, H)? {
  switch (maybeA, maybeB, maybeC, maybeD, maybeE, maybeF, maybeG, maybeH) {
  case (let a?, let b?, let c?, let d?, let e?, let f?, let g?, let h?):
    return (a, b, c, d, e, f, g, h)
  default:
    return nil
  }
}


public func zip<A, B, C, D, E, F, G, H, I>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?, _ maybeE: E?, _ maybeF: F?,
  _ maybeG: G?, _ maybeH: H?, _ maybeI: I?
) -> (A, B, C, D, E, F, G, H, I)? {
  switch (maybeA, maybeB, maybeC, maybeD, maybeE, maybeF, maybeG, maybeH, maybeI) {
  case (let a?, let b?, let c?, let d?, let e?, let f?, let g?, let h?, let i?):
    return (a, b, c, d, e, f, g, h, i)
  default:
    return nil
  }
}


public func zip<A, B, C, D, E, F, G, H, I, J>(
  _ maybeA: A?, _ maybeB: B?, _ maybeC: C?,
  _ maybeD: D?, _ maybeE: E?, _ maybeF: F?,
  _ maybeG: G?, _ maybeH: H?, _ maybeI: I?,
  _ maybeJ: J?
) -> (A, B, C, D, E, F, G, H, I, J)? {
  switch (maybeA, maybeB, maybeC, maybeD, maybeE, maybeF, maybeG, maybeH, maybeI, maybeJ) {
  case (let a?, let b?, let c?, let d?, let e?, let f?, let g?, let h?, let i?, let j?):
    return (a, b, c, d, e, f, g, h, i, j)
  default:
    return nil
  }
}
