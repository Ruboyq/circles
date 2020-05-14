//
//  TrendCommentController.swift
//  circles
//
//  Created by yjp on 2020/5/12.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class TrendCommentController: UIViewController {
    public static var trendId:String?
//    var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var commentArray: [CommentModel]!
    var isLoading = false
    
//    var data = CoreDataHandler()
    
    let reachability = try! Reachability()
    var urlSession: URLSession!
    var dataTask: URLSessionDataTask?
    
    var trendId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        URLProtocol.registerClass(MyURLProtocol.self)
        checkNetwork()
        setupSession()
        setupData()
        setupTableView()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        
    }
    
    func setupData() {
        commentArray = [CommentModel]()
//        for comment in self.data.fetchAll(){
//            resumeArray.append(CommentModel(name: resume.name!, school: resume.school!, grade: resume.grade!, img: resume.img!))
//        }
        self.getComment()
    }
    
    func setupTableView() {
//        if #available(iOS 13.0, *) {
//            tableView = UITableView(frame: self.view.bounds, style: .plain)
//        } else {
//            // Fallback on earlier versions
//            tableView = UITableView(frame: self.view.bounds, style: .plain)
//        }
//        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //        tableView.separatorColor = UIColor.red
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.estimatedRowHeight = 150
//        tableView.rowHeight = 130
        
        tableView.separatorEffect = UIBlurEffect(style: .dark)
        
        addPullToRefresh()
    }
    
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    
    func heightOfAttributedString(_ attributedString: NSAttributedString) -> CGFloat {
        let height : CGFloat =  attributedString.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 15 * 2, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        return ceil(height)
    }
}

extension TrendCommentController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > self.commentArray.count - 1 { return 0 }
        let tmp:NSAttributedString = NSAttributedString(string: self.commentArray[indexPath.row].remark)
        let layout : CGFloat = 15 + 35 + 15 + self.heightOfAttributedString(tmp) + 15
        return layout
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        if indexPath.row < commentArray.count {
//                cell.name.text = resumeArray[indexPath.row].name
//                cell.school.text = resumeArray[indexPath.row].school
//                cell.grade.text = resumeArray[indexPath.row].grade
//                cell.imgView.image = UIImage(named: resumeArray[indexPath.row].img)
            cell.nameLabel.text = self.commentArray[indexPath.row].uname
            cell.timeLabel.text = self.commentArray[indexPath.row].createTime
            cell.textView.text = self.commentArray[indexPath.row].remark
            let decodedData = NSData(base64Encoded:self.commentArray[indexPath.row].uicon, options:NSData.Base64DecodingOptions())

            let decodedimage = UIImage(data: decodedData! as Data)! as UIImage
            cell.headImage.image = decodedimage
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}


extension TrendCommentController {
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        print("handleRefresh")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            self.getComment()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func checkNetwork() {
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
    }
    func setupSession() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.protocolClasses = [MyURLProtocol.self]
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    func getComment() {
        dataTask?.cancel()
        var urlComponents = URLComponents(string: "http://192.168.1.6:8080/trend/comment/list")
        urlComponents?.query = "pid="+TrendCommentController.trendId!
        guard let url = urlComponents?.url else {
            return
        }
        dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            } else if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
//                    print(String(data: data, encoding: .utf8) ?? "")
                    let tmpModel = try JSONDecoder().decode(CommentResponse.self, from: data)
                    let tmpList = tmpModel.data
//                    commentArray.removeAll()
                    for comment in tmpList{
//                        let reData = CoreDataHandler()
//                        reData.addResume(name: resume.name, school: resume.school, grade: resume.grade, img: resume.img)
                        self.commentArray.append(comment)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        })
        dataTask?.resume()
    }
}

extension TrendCommentController: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let trust = challenge.protectionSpace.serverTrust {
                let credentials = URLCredential(trust: trust)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credentials)
                return
            }
        }
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
}
