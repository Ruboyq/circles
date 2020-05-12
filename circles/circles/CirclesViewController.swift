import UIKit

class CirclesViewController: UIViewController {
    
    var tableView: UITableView!
    var trendsListData: [String] = [String]()
    
    var refreshControl: UIRefreshControl!
    var isLoading: Bool = false
    
    let reachability = try! Reachability()
    var urlSession: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editAction))
        
        trendsListData.append("asdfa")
        trendsListData.append("adfaef")
        trendsListData.append("adggfaedsf")
        trendsListData.append("asdfa")
        trendsListData.append("adfaef")
        trendsListData.append("adggfaedsf")
        trendsListData.append("asdfa")
        trendsListData.append("adfaef")
        trendsListData.append("adggfaedsf")
        trendsListData.append("asdfa")
        trendsListData.append("adfaef")
        trendsListData.append("adggfaedsf")
        
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
        tableView.register(MyCirclesTableCell.self, forCellReuseIdentifier: "MyCirclesTableCell")
        tableView.register(LoadMoreTableCell.self, forCellReuseIdentifier: "LoadMoreTableCell")
        tableView.tableFooterView = UIView()
        
        tableView.setEditing(false, animated: false)
        self.view.addSubview(tableView)
        
        addPullToRefresh()
    }
    
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    
    
    @objc func editAction() {
        
    }
}

extension CirclesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        if section == 0{
    //            return "我关注的圈子"
    //        } else if section == 1{
    //            return "圈内动态"
    //        } else {
    //            return nil
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        } else if section == 1{
            return trendsListData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.textLabel?.text = "我关注的圈子 >"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
                //cell.selectionStyle = .default
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "FocusCirclesTableCell", for: indexPath) as! FocusCirclesTableCell
                let cirClesDateList: [String] = ["游戏", "娱乐", "校园","游戏", "娱乐", "校园","游戏", "娱乐", "校园"]
                cell.setCirclesDateList(cirClesDateList: cirClesDateList)
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.textLabel?.text = "圈子头条 >"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
                //cell.selectionStyle = .default
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "MyCirclesTableCell", for: indexPath) as! MyCirclesTableCell
                cell.imageview.image = UIImage(named: "logo")
                //cell.selectionStyle = .default
                return cell
            }
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "LoadMoreTableCell", for: indexPath) as! LoadMoreTableCell
            cell.loadingView.startAnimating()
            return cell
        }
    }
}

extension CirclesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 50
            } else {
                return 100
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 50
            } else {
                return 60
            }
        } else {
            return 50
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
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            trendsListData.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        trendsListData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let loadMoreCell = cell as? LoadMoreTableCell {
                loadMoreCell.loadingView.startAnimating()
                loadMore()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let loadMoreCell = cell as? LoadMoreTableCell {
                loadMoreCell.loadingView.stopAnimating()
            }
        }
    }
    
}

extension CirclesViewController {
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        print("pull refresh")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            //self.getResumes(num: 3, isEnd: false, state: 1)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadMore() {
        print("loading")
        
    }
}


extension CirclesViewController {
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

extension CirclesViewController: URLSessionDelegate {
    
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
