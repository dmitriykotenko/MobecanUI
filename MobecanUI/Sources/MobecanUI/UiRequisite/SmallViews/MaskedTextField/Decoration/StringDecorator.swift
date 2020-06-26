/// The rules to complement a string with auxiliary characters to make it more human-readable
/// (e. g.: "79008160428" → "+7 900 816-04-28" for phone numbers
/// or "1234567887654321" → "1234 5678 8765 4321" for credit card numbers).
public protocol StringDecorator {
  
  /// Complements a string with some auxiliary characters to make it more human-readable
  /// (e. g. "79008160428" → "+7 900 816-04-28").
  ///
  /// The result is a generalized string with every character marked as significant or auxiliary.
  func decorate(_ string: String) -> DecoratedString
}
