//
//  MultiPartMime.swift
//  MultiPartMimeHelper
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015-2019 Good Doug. All rights reserved.
//

import Foundation

/**
 An object for handling the conversion from Swift objects to multipart encoded form data
 for uploading to web services with POST
*/
open class MultiPartMime {
    var boundaryString = "===0xKhTmLbOuNdArY"
    
    let dictionary: Dictionary<String, MultiPartPart>
    
    public init(dict: Dictionary<String, MultiPartPart>) {
        self.dictionary = dict
    }
    
    /// Content-Type string useful for header and for the generated data
    open var contentTypeString: String {
        return "multipart/form-data; boundary=\(self.boundaryString)"
    }
    
    func partAsData(_ key: String, value: MultiPartPart) -> Data? {
        guard let keyData = MultiPartPart.stringWrapper(key).data, let valData = value.data else {
            return .none
        }
        var mutableData = Data()
        // boundary
        mutableData.append(MultiPartPart.stringWrapper("--\(self.boundaryString)\r\n").data!)
        // Content-Disposition: form-data; name="<key>"
        mutableData.append(MultiPartPart.stringWrapper("Content-Disposition: form-data; name=\"").data!)
        mutableData.append(keyData)
        mutableData.append(MultiPartPart.stringWrapper("\"").data!)
        if let fileName = value.fileName {
            mutableData.append(MultiPartPart.stringWrapper("; filename=\(fileName)").data!)
        }
        mutableData.append(MultiPartPart.stringWrapper("\r\n").data!)
        if let contentType = value.contentType {
            // Content-type: <contentType>
            mutableData.append(MultiPartPart.stringWrapper("Content-Type: \(contentType)\r\n").data!)
        }
        // the actual data...
        mutableData.append(MultiPartPart.stringWrapper("\r\n").data!)
        mutableData.append(valData as Data)
        mutableData.append(MultiPartPart.stringWrapper("\r\n").data!)
        return mutableData as Data
    }
    
    /// property for the data represented by this object.
    open var multiPartData: Data {
        let seedData = MultiPartPart.stringWrapper("multipart/form-data; boundary=\(self.boundaryString)\r\n").data!
        var val = self.dictionary.map({ (key, value) in self.partAsData(key, value: value) }).reduce(seedData, {
            (acc: Data, data: Data?) in
            var redVal = acc
            if let someData = data {
                redVal.append(someData)
            }
            return redVal
        })
        val.append(MultiPartPart.stringWrapper("--\(self.boundaryString)--\r\n").data!)
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
