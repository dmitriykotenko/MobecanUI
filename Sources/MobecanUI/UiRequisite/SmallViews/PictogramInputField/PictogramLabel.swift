//  Copyright © 2020 Mobecan. All rights reserved.


import LayoutKit
import RxCocoa
import RxSwift
import UIKit


public class PictogramLabel: LayoutableView {
  
  @RxUiInput public var text: AnyObserver<String?>
  
  private let characterView: (Character) -> UIView
  private let spacing: CGFloat
  private let alignment: NSTextAlignment
  
  private lazy var mainSubview = StackView(
    axis: .horizontal,
    spacing: spacing,
    childrenAlignment: .bottomFill
  )
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(characterView: @escaping (Character) -> UIView,
              spacing: CGFloat,
              alignment: NSTextAlignment = .left) {
    self.characterView = characterView
    self.spacing = spacing
    self.alignment = alignment
    
    super.init()
    
    translatesAutoresizingMaskIntoConstraints = false

    setupLayout()
    listenForText()
  }
  
  private func setupLayout() {
    layout = AlignedLayout(
      childAlignment: alignment.asLayoutKitAlignment,
      sublayouts: [mainSubview.asLayout]
    )
  }
  
  private func listenForText() {
    disposeBag {
      _text ==> { [weak self] in self?.displayText($0) }
    }
  }
  
  private func displayText(_ text: String?) {    
    mainSubview.removeArrangedSubviews()
    mainSubview.addArrangedSubviews((text ?? "").map(characterView))
  }

  public func sizeForText(_ text: String?) -> CGSize {
    let sampleLabel = PictogramLabel(
      characterView: characterView,
      spacing: spacing,
      alignment: alignment
    )
    
    sampleLabel.text.onNext(text)
    
    sampleLabel.layoutIfNeeded()
    
    return sampleLabel.frame.size
  }
  
  public func text(_ text: String?) -> Self {
    self.text.onNext(text)
    return self
  }
}


private extension NSTextAlignment {

  var asLayoutKitAlignment: Alignment {
    switch self {
    case .left:
      return .fillLeading
    case .right:
      return .fillTrailing
    case .natural:
      return .fillLeading
    case .center:
      return .fillCenter
    case .justified:
      return .fill
    @unknown default:
      fatalError("Text alignment \(self) is not yet supported")
    }
  }
}
