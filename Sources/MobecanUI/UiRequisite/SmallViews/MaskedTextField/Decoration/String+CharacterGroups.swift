/// Helpful character sets.
extension String {
  
  /// Roman digits (both uppercased and lowercased).
  static var romanDigits: String {
    let lowercaseDigits = "ivxlcdm"
    let uppercaseDigits = lowercaseDigits.uppercased()
    
    return lowercaseDigits + uppercaseDigits
  }
  
  /// Russian letters (both uppercased and lowercased).
  static var cyrillicLetters: String {
    let lowercaseLetters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    let uppercaseLetters = lowercaseLetters.uppercased()
    
    return lowercaseLetters + uppercaseLetters
  }
}
