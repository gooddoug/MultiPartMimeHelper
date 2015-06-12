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
    case PNGImage(UIImage, String?)
    case JPEGImage(UIImage, String?)
    case Data(NSData, String?)
    case File(String)
    
    var contentType: String? {
        switch self {
        case StringWrapper(_):
            return .None
        case PNGImage(let img):
            return .Some("image/png")
        case JPEGImage(let img):
            return .Some("image/jpeg")
        case Data(let d):
            return .Some("application/octet-stream")
        case File(let d):
            return .Some("application/octet-stream")
        }
    }
    
    var data: NSData? {
        switch self {
        case StringWrapper(let str):
            return str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        case PNGImage(let img, _):
            return UIImagePNGRepresentation(img)
        case JPEGImage(let img, _):
            return UIImageJPEGRepresentation(img, 1.0)
        case Data(let d, _):
            return .Some(d)
        case File(let path):
            return NSData(contentsOfFile: path)
        }
    }
    
    public var fileName: NSString? {
        switch self {
        case StringWrapper(_):
            return .None
        case PNGImage(_, let name):
            return name
        case JPEGImage(_, let name):
            return name
        case Data(_, let name):
            return name
        case File(let path):
            return path.lastPathComponent
        }
    }
}