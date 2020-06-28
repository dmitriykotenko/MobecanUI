//  Copyright © 2020 Mobecan. All rights reserved.


import RxCocoa
import RxSwift
import UIKit


public class PictogramLabel: UIView {
  
  @RxUiInput public var text: AnyObserver<String?>
  
  private let characterView: (Character) -> UIView
  private let spacing: CGFloat
  private let alignment: NSTextAlignment
  
  private let mainSubview = UIView()
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(characterView: @escaping (Character) -> UIView,
              spacing: CGFloat,
              alignment: NSTextAlignment = .left) {
    self.characterView = characterView
    self.spacing = spacing
    self.alignment = alignment
    
    super.init(frame: .zero)
    
    translatesAutoresizingMaskIntoConstraints = false

    addMainSubview()
    listenForText()
  }
  
  private func addMainSubview() {
    addSubview(mainSubview)
    
    mainSubview.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.top.left.greaterThanOrEqualToSuperview()
      $0.bottom.right.lessThanOrEqualToSuperview()
      
      switch alignment {
      case .left:
        $0.left.equalToSuperview()
      case .right:
        $0.right.equalToSuperview()
      case .natural:
        $0.leading.equalToSuperview()
      case .center:
        $0.centerX.equalToSuperview()
      case .justified:
        $0.leading.trailing.equalToSuperview()
      @unknown default:
        fatalError("Text alignment \(alignment) is not yet supported")
      }
    }
  }
  
  private func listenForText() {
    _text
      .subscribe(onNext: { [weak self] in
        self?.displayText($0)
      })
      .disposed(by: disposeBag)
  }
  
  private func displayText(_ text: String?) {    
    mainSubview.subviews.forEach { $0.removeFromSuperview() }
    
    mainSubview.putSubview(
      .hstack(
        alignment: .bottom,
        spacing: spacing,
        (text ?? "").map { characterView($0) }
      )
    )
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
