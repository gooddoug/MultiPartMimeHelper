//
//  ViewController.swift
//  TestMultiPartMime
//
//  Created by Doug Whitmore on 6/11/15.
//  Copyright (c) 2015 Good Doug. All rights reserved.
//

import UIKit
import MultiPartMimeHelper

class ViewController: UIViewController, NSURLConnectionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "ring")!
        let multiPartMime = MultiPartMime(dict: ["name":MultiPartPart.StringWrapper("ring.png"), "file":MultiPartPart.PNGImage(img, "ring.png")])
        let req = NSMutableURLRequest(URL: NSURL(string:"http://localhost:4567/upload")!)
        req.HTTPMethod = "POST"
        req.HTTPBody = multiPartMime.multiPartData
        req.setValue(multiPartMime.contentTypeString, forHTTPHeaderField:"Content-Type")
        _ = NSURLConnection(request: req, delegate: self, startImmediately: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func connectionDidFinishLoading(connection: NSURLConnection) {
        print("yay")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("dammit")
    }
}

