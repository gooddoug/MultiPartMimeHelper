//
//  MultiPartMimeHelperTests.swift
//  MultiPartMimeHelperTests
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015-2019 Good Doug. All rights reserved.
//

import UIKit
import XCTest
import MultiPartMimeHelper

class MultiPartMimeHelperTests: XCTestCase {
    
    let exampleString: String = "multipart/form-data; boundary====0xKhTmLbOuNdArY\r\n--===0xKhTmLbOuNdArY\r\nContent-Disposition: form-data; name=\"key1\"\r\n\r\nvalue1\r\n--===0xKhTmLbOuNdArY--\r\n"
    
    func simpleImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 10.0, height: 10.0))
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func testStringPartAsData() {
        let aKey = "string"
        let aValue = "this is a string"
        let aDict: Dictionary<String, MultiPartPart> = [aKey:MultiPartPart.stringWrapper(aValue)]
        let aMPM = MultiPartMime(dict: aDict)
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
    }
    
    func testStringPartAsDataAgainstKnownValue() {
        let aKey = "key1"
        let aValue = "value1"
        let aMPM = MultiPartMime(dict: [aKey: MultiPartPart.stringWrapper(aValue)])
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
        guard let aStr = String(data: testData, encoding: .utf8) else {
            XCTFail("shouldn't get a nil string from the testData")
            return
        }
        XCTAssertEqual(aStr, exampleString, "Strings should be equal:\n \(aStr) \n \(exampleString)")
    }
    
    func testMultiStringPartAsData() {
        let aKey1 = "string"
        let aValue1 = "this is a string"
        let aKey2 = "anotherString"
        let aValue2 = "this is a another string"
        let aMPM = MultiPartMime(dict:[aKey1:MultiPartPart.stringWrapper(aValue1), aKey2:MultiPartPart.stringWrapper(aValue2)])
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
    }
    
    func testImagePartAsData() {
        let aKey = "someImage"
        let aValue = simpleImage()
        let aMPM = MultiPartMime(dict:[aKey:MultiPartPart.pngImage(aValue, nil)])
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
    }
    
    func testMixedPartsAsData() {
        let aKey1 = "string"
        let aValue1 = "this is a string"
        let aKey2 = "someImage"
        let aValue2 = simpleImage()
        let testDict: Dictionary<String, MultiPartPart> = [aKey1:MultiPartPart.stringWrapper(aValue1), aKey2:MultiPartPart.pngImage(aValue2, nil)]
        let aMPM = MultiPartMime(dict:testDict)
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
    }
    
    func testDataPartAsData() {
        let aKey = "string"
        let aValue = "this is a string".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let aMPM = MultiPartMime(dict: [aKey: MultiPartPart.Data(aValue, nil)])
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
        XCTAssertTrue(testData.count > aValue.count, "testData should be larger than value")
    }
    
    func testPNGImageWithName() {
        let name = "name"
        let imagePart = MultiPartPart.pngImage(simpleImage(), name)
        let computedName = imagePart.fileName
        XCTAssertNotNil(computedName, "name shouldn't be nil")
        XCTAssertEqual(computedName!, name, "Name should be the same as what we passed in")
    }
    
    func testJPEGImageWithName() {
        let name = "name"
        let imagePart = MultiPartPart.jpegImage(simpleImage(), name)
        let computedName = imagePart.fileName
        XCTAssertNotNil(computedName, "name shouldn't be nil")
        XCTAssertEqual(computedName!, name, "Name should be the same as what we passed in")
    }
    
    func testDataWithName() {
        let name = "name"
        let aValue = "this is a string".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let dataPart = MultiPartPart.Data(aValue, name)
        let computedName = dataPart.fileName
        XCTAssertNotNil(computedName, "name shouldn't be nil")
        XCTAssertEqual(computedName!, name, "Name should be the same as what we passed in")
    }
    
    func testNoName() {
        let imagePart = MultiPartPart.pngImage(simpleImage(), nil)
        XCTAssertNil(imagePart.fileName, "fileName should be nil \(String(describing: imagePart.fileName))")
        let aValue = "this is a string".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let dataPart = MultiPartPart.Data(aValue, nil)
        XCTAssertNil(dataPart.fileName, "data fileName should be nil: \(String(describing: dataPart.fileName))")
    }
    
    func testFilePartAsData() {
        let fileName = "ring.png"
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.path(forResource: "ring", ofType: "png") else {
            XCTFail("Couldn't get the path")
            return
        }

        let filePart = MultiPartPart.file(path)
        let computedName = filePart.fileName
        XCTAssertNotNil(computedName, "name shouldn't be nil")
        XCTAssertEqual(computedName!, fileName, "Name should be the same as what we passed in")
        
        let aMPM = MultiPartMime(dict: ["file": filePart])
        let testData = aMPM.multiPartData
        XCTAssertNotNil(testData, "multipart data should not be nil")
        
    }
}
