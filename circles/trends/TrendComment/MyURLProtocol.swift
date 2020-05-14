//
//  MyURLProtocol.swift
//  circles
//
//  Created by yjp on 2020/5/13.
//  Copyright © 2020 group4. All rights reserved.
//

import Foundation

struct MyError: Error {
    var localizedDescription: String = "local date error"
}

class MyURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
//        if let url = request.url?.absoluteString, url.contains("192.168.2.100:8080/resume/data") {
//            return true
//        }
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .allowed)
        let str = "{\"message\": \"return local data\"}"
        if let tmpData = str.data(using: .utf8) {
            self.client?.urlProtocol(self, didLoad: tmpData)
        } else {
            self.client?.urlProtocol(self, didFailWithError: MyError())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
