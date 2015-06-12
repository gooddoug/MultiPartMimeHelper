//: Playground - noun: a place where people can play

import UIKit
import MultiPartMimeHelper

var str = "Hello, playground"

let aDict = ["test":MultiPartPart.StringWrapper("test value")]

let mpm = MultiPartMime(dict: aDict)

let val = mpm.multiPartData

let newStr = NSString(data: val, encoding: NSUTF8StringEncoding)