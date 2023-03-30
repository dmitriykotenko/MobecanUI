// Copyright © 2023 Mobecan. All rights reserved.


/// Interpretation of `SoftResult.hybrid` case when converting SoftResult to Swift.Result.
public enum SoftResultBias {

  /// Interpret `SoftResult.hybrid` as `.success`.
  case success

  /// Interpret `SoftResult.hybrid` as `.failure`.
  case failure
}
