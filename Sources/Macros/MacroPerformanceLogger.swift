// Copyright © 2025 Mobecan. All rights reserved.


import os.log
import os.signpost


private let log = OSLog(subsystem: "MobecanMacro", category: "expansion")


@inline(__always)
func logMacroPerformance<T>(_ name: StaticString, _ body: () -> T) -> T {
  let id = OSSignpostID(log: log)
  os_signpost(.begin, log: log, name: name, signpostID: id)
  defer { os_signpost(.end, log: log, name: name, signpostID: id) }
  return body()
}
