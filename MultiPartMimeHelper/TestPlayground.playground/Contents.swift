//: Playground - noun: a place where people can play

import UIKit
import MultiPartMimeHelper

var str = "Hello, playground"

let aDict = ["test":MultiPartPart.stringWrapper("test value")]

let mpm = MultiPartMime(dict: aDict)

let val = mpm.multiPartData

let newString = String(data: val, encoding: .utf8)

let str1 = "Foo"
let str2 = "Foo"

let isEqual = str1 == str2
