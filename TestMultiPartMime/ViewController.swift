//
//  ViewController.swift
//  TestMultiPartMime
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015-2016 Good Doug. All rights reserved.
//

import UIKit
import MultiPartMimeHelper

class ViewController: UIViewController, NSURLConnectionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "ring")!
        let multiPartMime = MultiPartMime(dict: ["name":MultiPartPart.stringWrapper("ring.png"), "file":MultiPartPart.pngImage(img, "ring.png")])
        let req = NSMutableURLRequest(url: URL(string:"http://localhost:4567/upload")!)
        req.httpMethod = "POST"
        req.httpBody = multiPartMime.multiPartData
        req.setValue(multiPartMime.contentTypeString, forHTTPHeaderField:"Content-Type")
        _ = NSURLConnection(request: req as URLRequest, delegate: self, startImmediately: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        print("yay")
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("dammit")
    }
}

