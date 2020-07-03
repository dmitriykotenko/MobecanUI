//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class LoadingButton: DiverseButton {
  
  public var isLoading: Bool {
    get { activityIndicator.isAnimating }
    
    set {
      newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
      // Use zero alpha to hide title label, because `titleLabel?.isHidden = true` does not work.
      titleLabel?.alpha = newValue ? 0 : 1
      isUserInteractionEnabled = !newValue
    }
  }
  
  private let activityIndicator: UIActivityIndicatorView
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(activityIndicator: UIActivityIndicatorView) {
    self.activityIndicator = activityIndicator
    
    super.init(frame: .zero)
    
    addActivityIndicator()
  }
  
  private func addActivityIndicator() {
    addSubview(activityIndicator)
    
    activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
  }
  
  override public var colorsByState: [ButtonColorsState] {
    didSet {
      let colors = colorsByState.first { $0.state == .normal }?.colors
      
      if let titleColor = colors?.title {
        activityIndicator.color = titleColor
      }
    }
  }
}


public extension Reactive where Base: LoadingButton {
  
  var isLoading: Binder<Bool> {
    Binder(base) { view, isLoading in
      view.isLoading = isLoading
    }
  }
}
