// Copyright © 2025 Mobecan. All rights reserved.

import UIKit


extension UIFontDescriptor.FeatureKey: @retroactive Hashable, Codable {}
extension UIFontDescriptor.SymbolicTraits: @retroactive Hashable, Codable {}


/// Улучшенная версия ``FontStyle``, поддерживающая протоколы ``Equatable``, ``Hashable`` и ``Codable``.
@MemberwiseInit
public struct FontStyle2: Equatable, Hashable, Codable, Lensable {

  public var familyName: String?
  public var size: CGFloat?
  public var weight: FontWeight?
  public var traits: FontTraits?
  public var features: [FontFeature]?

  public var fontStyleV1: FontStyle {
    .init(
      familyName: familyName,
      size: size,
      weight: weight?.uiFontWeight,
      traits: traits,
      features: features
    )
  }

  public func with(familyName: String? = nil,
                   size: CGFloat? = nil,
                   weight: FontWeight? = nil,
                   traits: FontTraits? = nil,
                   features: [FontFeature]? = nil) -> FontStyle2 {
    with(
      FontStyle2(
        familyName: familyName,
        size: size,
        weight: weight,
        traits: traits,
        features: features
      )
    )
  }
  
  public func with(_ fontStyle: FontStyle2) -> FontStyle2 {
    FontStyle2(
      familyName: fontStyle.familyName ?? familyName,
      size: fontStyle.size ?? size,
      weight: fontStyle.weight ?? weight,
      traits: fontStyle.traits ?? traits,
      features: fontStyle.features ?? features
    )
  }
  
  public func apply(to font: UIFont) -> UIFont {
    let fontDescriptor = font.fontDescriptor

    // If font descriptor has "NSCTFontUIUsageAttribute" attribute, family name will be not set correctly.
    // See https://gist.github.com/krzyzanowskim/e986890689e4b2f980d96be07de365f8
    var newAttributes = fontDescriptor.fontAttributes.filter { $0.key != .fontUiUsageAttribute }
    
    applyFamilyName(to: &newAttributes)
    applyWeight(to: &newAttributes)
    applyTraits(to: &newAttributes)
    applyFeatures(to: &newAttributes)
    
    let newFontDescriptor = UIFontDescriptor(fontAttributes: newAttributes)
    
    let newFontSize = size ?? fontDescriptor.pointSize
    
    return UIFont(
      descriptor: newFontDescriptor,
      size: newFontSize
    )
  }

  private func applyFamilyName(to newAttributes: inout [UIFontDescriptor.AttributeName: Any]) {
    if let familyName = familyName {
      newAttributes[.name] = nil
      newAttributes[.family] = familyName
    }
  }

  private func applyWeight(to newAttributes: inout [UIFontDescriptor.AttributeName: Any]) {
    if let weight = weight?.uiFontWeight {
      var newTraits = (newAttributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
      newTraits[.weight] = weight
      newAttributes[.traits] = newTraits
    }
  }
  
  private func applyTraits(to newAttributes: inout [UIFontDescriptor.AttributeName: Any]) {
    if let newValue = traits {
      var newTraits = (newAttributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
      
      let rawOldValue = (newTraits[.symbolic] as? NSNumber) ?? NSNumber(0)
      let oldValue = FontTraits(rawValue: rawOldValue.uint32Value)
      
      newTraits[.symbolic] = oldValue.union(newValue)
      newAttributes[.traits] = newTraits
    }
  }

  private func applyFeatures(to newAttributes: inout [UIFontDescriptor.AttributeName: Any]) {
    if let features = features {
      let oldFeatures = (newAttributes[.featureSettings] as? [FontFeature]) ?? []
      // Use `Set` to avoid feature duplicates.
      let newFeatures = (oldFeatures + features).asSet
      newAttributes[.featureSettings] = newFeatures.asArray
    }
  }
}
