// Copyright © 2020 Mobecan. All rights reserved.

import CoreLocation
import RxSwift


public extension Reactive where Base: CLGeocoder {

  func geocodeAddressString(_ string: String,
                            in region: CLRegion? = nil,
                            preferredLocale: Locale? = nil) -> Single<Result<[CLPlacemark]?, Error>> {
    let subject = AsyncSubject<Result<[CLPlacemark]?, Error>>()
    
    base.geocodeAddressString(
      string,
      in: region,
      preferredLocale: preferredLocale,
      completionHandler: { places, maybeError in
        if let error = maybeError {
          subject.onNext(.failure(error))
        } else {
          subject.onNext(.success(places))
        }
        
        subject.onCompleted()
      }
    )
    
    return subject.asSingle()
  }
}
