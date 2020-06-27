//  Copyright © 2020 Mobecan. All rights reserved.

import RxCocoa
import RxSwift
import UIKit


public class RatingView: UIView {
  
  public struct Icon {
    public let image: UIImage
    public let unselectedColor: UIColor
    public let selectedColor: UIColor
  }
  
  @RxUiInput(nil) public var rating: AnyObserver<Int?>
  @RxOutput(nil) public var desiredRating: Observable<Int?>
  
  private lazy var stars =
    possibleRatings.dropFirst().map { _ in starButton() }
  
  private let possibleRatings: ClosedRange<Int>
  private lazy var lowestRating = possibleRatings.lowerBound
  
  private let icon: Icon
  private let iconSize: CGSize?
  private let spacing: CGFloat?
  private let isEditable: Bool

  private let disposeBag = DisposeBag()
  
  public required init?(coder: NSCoder) { interfaceBuilderNotSupportedError() }
  
  public init(possibleRatings: ClosedRange<Int>,
              icon: Icon,
              iconSize: CGSize? = nil,
              spacing: CGFloat? = nil,
              isEditable: Bool) {
    self.possibleRatings = possibleRatings
    self.icon = icon
    self.iconSize = iconSize
    self.spacing = spacing
    self.isEditable = isEditable
    
    super.init(frame: .zero)

    addSubviews()
    displayRating()
    setupEditing()
  }
  
  private func addSubviews() {
    addSingleSubview(.hstack(stars))
  }
  
  private func starButton() -> UIButton {
    let actualIconSize = iconSize ?? icon.image.size
    let actualSpacing = spacing ?? 0.2 * actualIconSize.width

    let button = DiverseButton()
    
    _ = button.imageView?
      .contentMode(.scaleAspectFit)
      .size(actualIconSize)

    // Button's width and height must be set after .imageView's width and height.
    // Otherwise, autolayout engine generates a warning and breaks some constraints.
    _ = button
      .image(icon.image.withRenderingMode(.alwaysTemplate))
      .width(actualIconSize.width + actualSpacing)
      .height(actualIconSize.height)

    button.contentEdgeInsets = .horizontal(actualSpacing / 2)

    _ = button.colors([
      .normal(tint: icon.unselectedColor),
      .selected(tint: icon.selectedColor)
    ])
    
    return button
  }
  
  private func displayRating() {
    _rating.asObservable()
      .bind(to: _desiredRating)
      .disposed(by: disposeBag)

    desiredRating
      .map { [lowestRating] in $0 ?? lowestRating }
      .clipped(inside: possibleRatings)
      .subscribe(onNext: { [weak self] in self?.displayRating($0) })
      .disposed(by: disposeBag)
  }
  
  private func displayRating(_ rating: Int) {
    stars.prefix(rating - lowestRating).forEach { $0.isSelected = true }
    stars.dropFirst(rating - lowestRating).forEach { $0.isSelected = false }
  }
  
  private func setupEditing() {
    isEditable ? enableEditing() : disableEditing()
  }
  
  private func enableEditing() {
    stars.forEach { $0.isUserInteractionEnabled = true }

    zip(stars, possibleRatings.dropFirst()).forEach { star, rating in
      star.rx.tap
        .map { rating }
        .neverEnding()
        .bind(to: _desiredRating)
        .disposed(by: disposeBag)
    }
  }
  
  private func disableEditing() {
    stars.forEach { $0.isUserInteractionEnabled = false }
  }
}
