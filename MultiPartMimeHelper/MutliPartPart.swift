//
//  MutliPartPart.swift
//  MultiPartMimeHelper
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015 Good Doug. All rights reserved.
//

import UIKit

/**
*  A valid part for MultiPartMime
*/
public enum MultiPartPart {
    case StringWrapper(String)
    case Image(UIImage, String?)
    case Data(NSData, String?)
    
    var contentType: String? {
        switch self {
        case StringWrapper(_):
            return .None
        case Image(let img):
            return .Some("image/png")
        case Data(let d):
            return .Some("application/octet-stream")
        }
    }
    
    var data: NSData? {
        switch self {
        case StringWrapper(let str):
            return str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        case Image(let img, _):
            return UIImagePNGRepresentation(img)
        case Data(let d, _):
            return .Some(d)
        }
    }
    
    public var fileName: NSString? {
        switch self {
        case StringWrapper(_):
            return .None
        case Image(_, let name):
            return name
        case Data(_, let name):
            return name
        }
    }
}