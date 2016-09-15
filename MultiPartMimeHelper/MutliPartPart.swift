//
//  MutliPartPart.swift
//  MultiPartMimeHelper
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015-2016 Good Doug. All rights reserved.
//

import UIKit

/**
  A valid part for MultiPartMime
*/
public enum MultiPartPart {
    /**
      Wraps a plain string
    */
    case stringWrapper(String)
    /**
      wraps a UIImage for use as a PNG
    */
    case pngImage(UIImage, String?)
    /**
      wraps a UIImage for use as a JPEG
    */
    case jpegImage(UIImage, String?)
    /**
      wraps an Data
    */
    case Data(Foundation.Data, String?)
    /**
      wraps a filepath for the file to be sent
    */
    case file(String)
    
    /// returns the Content-Type for the wrapped part
    var contentType: String? {
        switch self {
        case .stringWrapper(_):
            return .none
        case .pngImage( _):
            return .some("image/png")
        case .jpegImage( _):
            return .some("image/jpeg")
        case .Data( _):
            return .some("application/octet-stream")
        case .file( _):
            return .some("application/octet-stream")
        }
    }
    
    /// returns the actual data for the wrapped part
    var data: Foundation.Data? {
        switch self {
        case .stringWrapper(let str):
            return str.data(using: String.Encoding.utf8, allowLossyConversion: false)
        case .pngImage(let img, _):
            return UIImagePNGRepresentation(img)
        case .jpegImage(let img, _):
            return UIImageJPEGRepresentation(img, 1.0)
        case .Data(let d, _):
            return .some(d)
        case .file(let path):
            return (try? Foundation.Data(contentsOf: URL(fileURLWithPath: path)))
        }
    }
    
    /// returns the file name for the wrapped part (Strings don't typically have filenames)
    public var fileName: String? {
        switch self {
        case .stringWrapper(_):
            return .none
        case .pngImage(_, let name):
            return name
        case .jpegImage(_, let name):
            return name
        case .Data(_, let name):
            return name
        case .file(let path):
            return URL(fileURLWithPath:path).lastPathComponent
        }
    }
}
