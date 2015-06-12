//
//  MultiPartMime.swift
//  MultiPartMimeHelper
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015 Good Doug. All rights reserved.
//

import Foundation

/**
 An object for handling the conversion from Swift objects to multipart encoded form data
 for uploading to web services with POST
*/
public class MultiPartMime {
    var boundaryString = "===0xKhTmLbOuNdArY"
    
    let dictionary: Dictionary<String, MultiPartPart>
    
    public init(dict: Dictionary<String, MultiPartPart>) {
        self.dictionary = dict
    }
    
    /// Content-Type string useful for header and for the generated data
    public var contentTypeString: String {
        return "multipart/form-data; boundary=\(self.boundaryString)"
    }
    
    func partAsData(key: String, value: MultiPartPart) -> NSData? {
        if let keyData = MultiPartPart.StringWrapper(key).data, let valData = value.data {
            var mutableData = NSMutableData()
            // boundary
            mutableData.appendData(MultiPartPart.StringWrapper("--\(self.boundaryString)\r\n").data!)
            // Content-Disposition: form-data; name="<key>"
            mutableData.appendData(MultiPartPart.StringWrapper("Content-Disposition: form-data; name=\"").data!)
            mutableData.appendData(keyData)
            mutableData.appendData(MultiPartPart.StringWrapper("\"").data!)
            if let fileName = value.fileName {
                mutableData.appendData(MultiPartPart.StringWrapper("; filename=\(fileName)").data!)
            }
            mutableData.appendData(MultiPartPart.StringWrapper("\r\n").data!)
            if let contentType = value.contentType {
                // Content-type: <contentType>
                mutableData.appendData(MultiPartPart.StringWrapper("Content-Type: \(contentType)\r\n").data!)
            }
            // the actual data...
            mutableData.appendData(MultiPartPart.StringWrapper("\r\n").data!)
            mutableData.appendData(valData)
            mutableData.appendData(MultiPartPart.StringWrapper("\r\n").data!)
            return mutableData
        }
        return .None
    }
    
    /// property for the data represented by this object.
    public var multiPartData: NSData {
        var seedData = NSMutableData(data: MultiPartPart.StringWrapper("multipart/form-data; boundary=\(self.boundaryString)\r\n").data!)
        var val = reduce(map(self.dictionary, { (key, value) in self.partAsData(key, value: value) }), seedData, {
            (acc: NSMutableData, data: NSData?) in
            if let someData = data {
                acc.appendData(someData)
            }
            return acc
        })
        val.appendData(MultiPartPart.StringWrapper("--\(self.boundaryString)--\r\n").data!)
        return val
    }
}

// This is what the data should look like:
/*
multipart/form-data; boundary====0xKhTmLbOuNdArY
--===0xKhTmLbOuNdArY
Content-Disposition: form-data; name="key1"

value1
--===0xKhTmLbOuNdArY
Content-Disposition: form-data; name="key2"
Content-Type: image/png

0x\89PNGdeadbeef...
--===0xKhTmLbOuNdArY--
*/
