//  Copyright © 2020 Mobecan. All rights reserved.


public func interfaceBuilderNotSupportedError(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Interface builder not supported", file: file, line: line)
}
