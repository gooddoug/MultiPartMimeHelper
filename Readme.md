MultiPartMimeHelper is a simple framework for encoding items into multipart data appropriate for putting into the HTTPBody of an NSURLRequest.

This is useful in particular for image or file upload. Most web services accept multpart encoded request bodies for file upload. This framework makes it simple to generate the mutlipart encoded data. Wrap each of the items you need to POST to the web service as a particular MultiPartPart and use those to create a MultiPartMime object.

## Usage
```swift
import MultiPartMimeHelper

func upload(img: UIImage, filename: String) {
    let multiPartMime = MultiPartMime(dict: ["name": MultiPartPart.StringWrapper(filename), "file": MultiPartPart.PNGImage(img, filename)])
    var req = NSMutableURLRequest(URL: NSURL(string: "http://localhost:4567/upload")!)
    req.HTTPMethod = "POST"
    req.HTTPBody = multiPartMime.multiPartData
    req.setValue(multiPartMime.contentTypeString, forHTTPHeaderField:"Content-Type")
    var conn = NSURLConnection(request: req, delegate: self, startImmediately: true)
}

func upload(avatarPath: String, username: String, bio: String) {
    let multiPartMime = MultiPartMime(dict: ["avatar": MultiPartPart.File(path)], "username": MultiPartPart.String(username), "bio": MultiPartPart(bio)])
    var req = NSMutableURLRequest(URL: NSURL(string: "http://localhost:4567/upload")!)
    req.HTTPMethod = "POST"
    req.HTTPBody = multiPartMime.multiPartData
    req.setValue(multiPartMime.contentTypeString, forHTTPHeaderField:"Content-Type")
    var conn = NSURLConnection(request: req, delegate: self, startImmediately: true)
}
```

## Installing
You can download and build the framwork yourself and add it to your project. Cocoapods support is coming soon. Finally, you can copy the MultiPartMime.swift and MultiPartPart.swift files into your project and not worry about frameworks at all.

## Contributing
Please use pull requests if you know how to fix the issue you are having. If you can't fix the issue, please file a ticket.

## License
MIT License, see the 'LICENSE' file for details
