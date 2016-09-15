//
//  Helpers.swift
//  MultiPartMimeHelper
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015-2016 Good Doug. All rights reserved.
//

import Foundation

public func undefined<T>(_ msg: String = "") -> T {
    fatalError("undefined: \(msg)")
}
