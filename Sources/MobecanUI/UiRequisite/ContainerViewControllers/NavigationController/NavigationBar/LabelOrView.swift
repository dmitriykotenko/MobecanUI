// Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import SnapKit
import UIKit


public class LabelOrView: UIView, DataView {
  
  public typealias Value = StringOrView
  @RxUiInput(nil) public var value: AnyObserver<StringOrView?>
  
  private let label: UILabel
  private let customViewContainer = UIView.autolayoutStretchableSpacer()
  
  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(label: UILabel) {
    self.label = label
    
    super.init(frame: .zero)
    
    insertSubviews()
    displayValue()
  }
  
  private func insertSubviews() {
    putSingleSubview(.vstack([label, customViewContainer]))
  }
  
  private func displayValue() {
    disposeBag {
      _value ==> { [weak self] in self?.displayValue($0) }
    }
  }
  
  private func displayValue(_ value: StringOrView?) {
    isVisible = (value != nil)
    
    switch value {
    case .string(let string):
      label.isVisible = true
      customViewContainer.isVisible = false
      label.text = string
    case .attributedString(let attributedString):
      label.isVisible = true
      customViewContainer.isVisible = false
      label.attributedText = attributedString
    case .view(let view):
      label.isVisible = false
      customViewContainer.isVisible = true
      customViewContainer.putSingleSubview(view)
    case nil:
      label.isVisible = false
      customViewContainer.isVisible = false
      customViewContainer.removeAllSubviews()
    }
  }
}
