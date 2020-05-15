//
//  ApiUtil.swift
//  circles
//
//  Created by lucien on 2020/5/14.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

struct CirclesResponseData: Codable {
    var code: Int = 0
    var msg: String = ""
    var data: [String] = [String]()
}

struct CommonResponseData: Codable {
    var code: Int = 0
    var msg: String = ""
    var data: String = ""
}

public class ApiDataUtil: NSObject, URLSessionDelegate {
    
    var baseurl: String = "http://192.168.2.121:8080/"
    var userName: String = "test"
    
    public static var circlesMap: [String: String] = ["数码": "digit", "影视": "tv", "时尚": "fashion", "体育": "pe", "校园": "campus", "亲子": "pchild", "科学": "science", "动漫": "cartoon", "游戏": "game", "法律": "law", "故事": "story", "萌宠": "chao"]
    
    public static var trendsListData: [String] = [String]()
    public static var circlesDataList: [String] = [String]()
    
    let reachability = try! Reachability()
    var urlSession: URLSession!
    var dataTask: URLSessionDataTask?
    
    func initUtil() {
        setupSession()
    }
    
    func initData() {
        //从coredata读取数据
    }
    
    func checkNetwork() -> Bool {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        return reachability.connection != .unavailable
    }
    
    func setupSession() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        //config.protocolClasses = [MyURLProtocol.self]
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                let credentials = URLCredential(trust: trust)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credentials)
                return
            }
        }
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    
    func refreshMyCircles(vc: UIViewController, state: Int) {
        dataTask?.cancel()
        let url = URL(string: baseurl+"circles/mycircles")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.allHTTPHeaderFields=["Content-Type":"application/json"]
        let paramStr = "{\"userName\":\"\(userName)\"}"
        //将参数字符串转换为二进制Data数据
        let paramData = paramStr.data(using: .utf8)
        request.httpBody = paramData
        
        dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    print(String(data: data, encoding: .utf8) ?? "")
                    let tmpModel = try JSONDecoder().decode(CirclesResponseData.self, from: data)
                    ApiDataUtil.circlesDataList = tmpModel.data
                } catch {
                    print("Error: \(error)")
                }
            }
            DispatchQueue.main.async {
                if state == 1 {
                    vc.viewDidAppear(true)
                }
            }
        })
        dataTask?.resume()
    }
    
    func deleteCircle(vc: UIViewController, circle: String) {
        if !checkNetwork() {
            CommonService.showMsgbox(vc: vc, _message: "网络无法连接")
            return
        }
        
        dataTask?.cancel()
        let url = URL(string: baseurl+"circles/delete")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.allHTTPHeaderFields=["Content-Type":"application/json"]
        let paramStr = "{\"userName\":\"\(userName)\",\"circle\":\"\(circle)\"}"
        //将参数字符串转换为二进制Data数据
        let paramData = paramStr.data(using: .utf8)
        request.httpBody = paramData
        
        dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                CommonService.showMsgbox(vc: vc, _message: "网络较慢，请稍后重试")
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print(String(data: data, encoding: .utf8) ?? "")
                
                var i = 0
                for str in ApiDataUtil.circlesDataList {
                    if str == circle {
                        ApiDataUtil.circlesDataList.remove(at: i)
                        break
                    }
                    i += 1
                }
                DispatchQueue.main.async {
                    vc.viewDidAppear(true)
                }
            }
        })
        dataTask?.resume()
    }
    
    func addCircle(vc: UIViewController, circle: String) {
        if !checkNetwork() {
            CommonService.showMsgbox(vc: vc, _message: "网络无法连接")
            return
        }
        
        dataTask?.cancel()
        let url = URL(string: baseurl+"circles/add")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.allHTTPHeaderFields=["Content-Type":"application/json"]
        let paramStr = "{\"userName\":\"\(userName)\",\"circle\":\"\(circle)\"}"
        //将参数字符串转换为二进制Data数据
        let paramData = paramStr.data(using: .utf8)
        request.httpBody = paramData
        
        dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                CommonService.showMsgbox(vc: vc, _message: "网络较慢，请稍后重试")
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print(String(data: data, encoding: .utf8) ?? "")
                
                ApiDataUtil.circlesDataList.append(circle)
                DispatchQueue.main.async {
                    vc.viewDidAppear(true)
                }
            }
        })
        dataTask?.resume()
    }
    
}