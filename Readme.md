MultiPartMimeHelper is a simple framework for encoding items into multipart data appropriate for putting into the HTTPBody of an NSURLRequest.

This is useful in particular for image or file upload. Most web services accept multpart encoded request bodies for file upload. This framework makes it simple to generate the mutlipart encoded data. Wrap each of the items you need to POST to the web service as a particular MultiPartPart and use those to create a MultiPartMime object.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Installing
[Carthage](https://github/com/carthage/carthage) is the recommended way to install this. Add the following to your cartfile:
```ruby
github "gooddoug/MultiPartMimeHelper"
```

Optionally, you can copy the MultiPartMime.swift and MultiPartPart.swift files into your project and not worry about frameworks at all.


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

Included in the repository is a test server written with Sinatra test_app.rb
To use, install the dependent gems:
```shell
gem install sinatra
gem install haml
```
Then run the server:
```shell
ruby test_app.rb
```

## Contributing
Please use pull requests if you know how to fix the issue you are having. If you can't fix the issue, please file a ticket.

## License
MIT License, see the 'LICENSE' file for details
