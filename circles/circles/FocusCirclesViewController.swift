//
//  FocusCirclesViewController.swift
//  circles
//
//  Created by lucien on 2020/5/12.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class FocusCirclesViewController: UIViewController {
    
    var tableView: UITableView!
    var circlesDataList: [String] = [String]()
    
    var refreshControl: UIRefreshControl!
    
    let reachability = try! Reachability()
    var urlSession: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editAction))
        
        circlesDataList.append("asdfa")
        circlesDataList.append("adfaef")
        circlesDataList.append("adggfaedsf")
        
        initUI()
        addPullToRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func initUI() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = 140
        //tableView.estimatedRowHeight = 140
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 10))
        tableView.tableHeaderView = headerView
        //tableView.tableFooterView = headerView
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(FocusCirclesTableCell.self, forCellReuseIdentifier: "FocusCirclesTableCell")
        tableView.register(OneFocusCircleTableCell.self, forCellReuseIdentifier: "OneFocusCircleTableCell")
        tableView.tableFooterView = UIView()
        
        tableView.setEditing(false, animated: false)
        self.view.addSubview(tableView)
    }
    
    @objc func receiverNotification(){
        self.initUI()
    }
    
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh2(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh2(_ sender: UIRefreshControl) {
        print("pull refresh")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            //self.getResumes(num: 3, isEnd: false, state: 1)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension FocusCirclesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return circlesDataList.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.textLabel?.text = "我关注的圈子"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
                //cell.selectionStyle = .default
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OneFocusCircleTableCell", for: indexPath) as! OneFocusCircleTableCell
                cell.imageview.image = UIImage(named: "logo")
                cell.circleTextLabel.text = circlesDataList[indexPath.row-1]
                //cell.selectionStyle = .default
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.textLabel?.text = "更多圈子"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
                //cell.selectionStyle = .default
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FocusCirclesTableCell", for: indexPath) as! FocusCirclesTableCell
                cell.setViewController(vc: self)
                cell.setCirclesDateList(cirClesDateList: circlesDataList)
                //self.navigationController
                return cell
            }
        }
    }
}

extension FocusCirclesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else {
                return 60
            }
        } else {
            if indexPath.row == 0 {
                return 50
            } else {
                return 50
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print(indexPath.row)
        if indexPath.section == 0 {
            //let resume = ResumeViewController()
            //self.present(resume, animated: true, completion: nil)
            //self.navigationController?.pushViewController(resume, animated: true)
        }
    }
    
}

extension FocusCirclesViewController {
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
        config.timeoutIntervalForRequest = 5
        //config.protocolClasses = [MyURLProtocol.self]
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    
    
}

extension FocusCirclesViewController: URLSessionDelegate {
    
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

