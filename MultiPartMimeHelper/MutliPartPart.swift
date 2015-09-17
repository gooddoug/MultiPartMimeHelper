//
//  MutliPartPart.swift
//  MultiPartMimeHelper
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015 Good Doug. All rights reserved.
//

import UIKit

/**
  A valid part for MultiPartMime
*/
public enum MultiPartPart {
    /**
      Wraps a plain string
    */
    case StringWrapper(String)
    /**
      wraps a UIImage for use as a PNG
    */
    case PNGImage(UIImage, String?)
    /**
      wraps a UIImage for use as a JPEG
    */
    case JPEGImage(UIImage, String?)
    /**
      wraps an NSData
    */
    case Data(NSData, String?)
    /**
      wraps a filepath for the file to be sent
    */
    case File(String)
    
    /// returns the Content-Type for the wrapped part
    var contentType: String? {
        switch self {
        case StringWrapper(_):
            return .None
        case PNGImage( _):
            return .Some("image/png")
        case JPEGImage( _):
            return .Some("image/jpeg")
        case Data( _):
            return .Some("application/octet-stream")
        case File( _):
            return .Some("application/octet-stream")
        }
    }
    
    /// returns the actual data for the wrapped part
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
    
    /// returns the file name for the wrapped part (Strings don't typically have filenames)
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
            return NSURL(fileURLWithPath:path).lastPathComponent
        }
    }
}