//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


open class LoadingButton: DiverseButton {
  
  open var isLoading: Bool {
    get { activityIndicator.isAnimating }
    
    set {
      newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
      // Use zero alpha to hide title label, because `titleLabel?.isHidden = true` does not work.
      titleLabel?.alpha = newValue ? 0 : 1
      isUserInteractionEnabled = !newValue
      updateImageViewAlpha()
    }
  }

  private let activityIndicator: ActivityIndicatorProtocol
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(activityIndicator: ActivityIndicatorProtocol) {
    self.activityIndicator = activityIndicator
    
    super.init(frame: .zero)
    
    addActivityIndicator()
  }
  
  private func addActivityIndicator() {
    addSubview(activityIndicator)
    
    activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
  }
  
  override open var colorsByState: [ButtonColorsState] {
    didSet {
      let colors = colorsByState.first { $0.state == .normal }?.colors
      
      if let titleColor = colors?.title {
        activityIndicator.color = titleColor
      }
    }
  }

  override open func setImage(_ image: UIImage?,
                              for state: UIControl.State) {
    super.setImage(image, for: state)
    updateImageViewAlpha()
  }

  override open var isEnabled: Bool { didSet { updateImageViewAlpha() } }
  override open var isHighlighted: Bool { didSet { updateImageViewAlpha() } }
  override open var isSelected: Bool { didSet { updateImageViewAlpha() } }

  private func updateImageViewAlpha() {
    imageView?.alpha = isLoading ? 0 : 1
  }
}


public extension Reactive where Base: LoadingButton {
  
  var isLoading: Binder<Bool> {
    Binder(base) { view, isLoading in
      view.isLoading = isLoading
    }
  }
}
