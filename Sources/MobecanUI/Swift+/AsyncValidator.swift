// Copyright © 2021 Mobecan. All rights reserved.

import RxSwift


public typealias AsyncValidator<Value, SomeError: Error> = (Value) -> Single<Result<Value, SomeError>>
