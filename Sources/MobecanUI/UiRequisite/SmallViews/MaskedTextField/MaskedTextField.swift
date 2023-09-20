import UIKit


/// Enhanced text field:
///
/// — automatically places auxiliary characters during the editing
/// — does not allow the user to enter some invalid texts
///
/// ``.text`` property contains only significant characters – i. e. the characters entered by the user.
/// For instance, when the decoration template is "+_ ___ ___-__-__"
/// and the user sees a phone number +7 900 816-04-28 on the screen,
/// ``.text`` property will contain the value "79008160428".
/// Spaces, dashes and plus sign are not visible outside.
public class MaskedTextField: UITextField, SizableView {

  public let sizer = ViewSizer()
  
  public override var delegate: UITextFieldDelegate? {
    get { outerDelegate.parent }
    set { outerDelegate.parent = newValue }
  }
  
  public override var text: String? {
    set {
      decoratedText = newValue.map(decorator.decorate)

      super.attributedText = decoratedText.map { attributor.attributedString($0) }

      sendActions(for: .valueChanged)

      NotificationCenter.default.post(
        name: UITextField.textDidChangeNotification,
        object: self
      )
    }
    
    get {
      decoratedText?.significantContent
    }
  }
  
  func userDidChangeText(to newText: String?) {
    text = newText
    sendActions(for: .editingChanged)
  }
  
  /// Text field's current text with every character marked as significant or not significant.
  public internal(set) var decoratedText: DecoratedString?
  
  private var decorator: StringDecorator = EmptyStringDecorator()
  private var decorationEngine: TextFieldDecorationEngine?
  private var sanitizationEngine: TextFieldSanitizationEngine?
  private var validationEngine: TextFieldValidationEngine?

  private var delegatesChain: [TextFieldDelegateProxy] = []
  
  // swiftlint:disable:next weak_delegate
  private var outerDelegate: TextFieldDelegateProxy = TextFieldSurgeon()
  
  private var copyPaster: TextFieldCopyPaster?
  private var attributor: DecoratedStringAttributor = EmptyStringAttributor()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    privateInit()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    privateInit()
  }
  
  /// Creates ``MaskedTextField`` with predefined decoration, validation, sanitization and attribution.
  ///
  /// - parameters:
  ///     - decoration: Rules to place auxiliary characters during the editing.
  ///     E. g. for phone numbers the rules can be described as a template "+_ ___ ___-__-__".
  ///     (Underscores represent text entered by the user.
  ///     All other characters are auxiliary and placed automatically during the editing.)
  ///     Default value is ``.none`` which means no decoration.
  ///     - sanitization: Rules to remove single undesirable characters from user input.
  ///     E. g. when the user inserts phone number via the clipboard,
  ///     the number is usually formatted and looks like this: "+7 (900) 555-22-11".
  ///     But we usually want to remove everything except digits and paste "79005552211".
  ///     Default value in ``.none`` which means that every character is acceptable.
  ///     - validation: A filter that prohibits the user to change field's text
  ///     if new text is inappropriate. E. g. when entering time of day,
  ///     the text is appropriate if it contains only digits and its length is less than or equal to 4.
  ///     Default value is ``.none`` and means everything is valid.
  ///     - attribution: Styling for text field's text. E. g. when entering price,
  ///     it may be appropriate to mute currency sign's color or to reduce currency sign's font size.
  ///     Default value is ``.none`` and means no styling.
  ///
  /// Validation and sanitization work only for user-initiated changes.
  /// They do not work when ``.text`` property is changed programmatically.
  /// Decoration works for both programmatic and user-initiated changes.
  public convenience init(decoration: TextFieldDecoration = .none,
                          sanitization: TextFieldSanitization = .none,
                          validation: TextFieldValidation = .none,
                          attribution: TextFieldAttribution = .none) {
    self.init(frame: .zero)
    
    setDecoration(decoration)
    setSanitization(sanitization)
    setValidation(validation)
    setAttribution(attribution)

    withStretchableWidth()
    
    text = ""
  }
  
  private func privateInit() {
    decorationEngine = TextFieldDecorationEngine(textField: self)
    
    guard let decorationEngine = decorationEngine else {
      fatalError("Could not initialize TextFieldDecorationEngine.")
    }
    
    sanitizationEngine = TextFieldSanitizationEngine()
    
    guard let sanitizationEngine = sanitizationEngine else {
      fatalError("Could not initialize TextFieldSanitizationEngine.")
    }
    
    validationEngine = TextFieldValidationEngine()
    
    guard let validationEngine = validationEngine else {
      fatalError("Could not initialize TextFieldValidationEngine.")
    }
    
    setupDelegatesChain([sanitizationEngine, decorationEngine, validationEngine])
    
    guard let superDelegate = super.delegate else {
      fatalError("super.delegate was not initialized.")
    }
    
    copyPaster = TextFieldCopyPaster(
      textField: self,
      innerDelegate: superDelegate,
      outerDelegate: outerDelegate
    )
  }
  
  /// Build delegates chain for the text field.
  ///
  /// The first delegate in the chain connects directly to the text field.
  /// The .outerDelegate connects to the last delegate in the chain.
  private func setupDelegatesChain(_ delegates: [TextFieldDelegateProxy]) {
    delegatesChain = delegates
    
    // The first delegate in the chain connects directly to the text field.
    super.delegate = delegatesChain.first
    
    // Every subsequent delegate connects to its predecessor.
    let parents = delegatesChain.dropFirst()
    
    for (child, parent) in zip(delegatesChain, parents) {
      child.parent = parent
    }
    
    // The external delegate connects to the last delegate in the chain.
    delegatesChain.last?.parent = outerDelegate
  }
  
  /// Sets rules to place auxiliary characters when editing a text field.
  ///
  /// In most cases the rules can be described as some template.
  /// E. g., the template for the phone number could be "+_ ___ ___-__-__".
  /// (In this case, when the user enters "79001113355", the onscreen text will be +7 900 111-33-55".).
  /// Underscores represent text entered by the user.
  /// Every character except underscore considered auxiliary.
  ///
  /// For elaborate cases, custom decorator can be specified via .custom option.
  public func setDecoration(_ decoration: TextFieldDecoration) {
    decorator = decoration.parse()
    
    // Apply new decoration to current text.
    applyDecoration()
  }
  
  /// Sets a filter which removes inappropriate characters from user input.
  public func setSanitization(_ sanitization: TextFieldSanitization) {
    sanitizationEngine?.sanitizer = sanitization.parse()
  }
  
  /// Sets a filter which prohibits text changing when new text is inappropriate.
  public func setValidation(_ validation: TextFieldValidation) {
    validationEngine?.validator = validation.parse()
  }

  /// Sets a transformer which adds attributes to text field's text.
  public func setAttribution(_ attribution: TextFieldAttribution) {
    attributor = attribution.parse()
    textStyleUpdated()
  }

  private func applyDecoration() {
    let currentText = text
    text = currentText
  }
  
  public override func cut(_ sender: Any?) { copyPaster?.cut() }
  public override func paste(_ sender: Any?) { copyPaster?.paste() }

  public override var font: UIFont? { didSet { textStyleUpdated() } }
  public override var textColor: UIColor? { didSet { textStyleUpdated() } }
  public override var minimumFontSize: CGFloat { didSet { textStyleUpdated() } }
  public override var adjustsFontSizeToFitWidth: Bool { didSet { textStyleUpdated() } }
  public override var adjustsFontForContentSizeCategory: Bool { didSet { textStyleUpdated() } }
  public override var defaultTextAttributes: [NSAttributedString.Key : Any] { didSet { textStyleUpdated() } }

  private func textStyleUpdated() { self.text = text }

  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizer.sizeThatFits(
      size,
      nativeSizing: super.sizeThatFits
    )
  }
}
