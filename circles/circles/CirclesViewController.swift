import UIKit

class CirclesViewController: UIViewController {
    
    var tableView: UITableView!
    var trendsListData: [String] = [String]()
    static var circlesDataList: [String] = [String]()
    
    var refreshControl: UIRefreshControl!
    var isLoading: Bool = false
    
    let reachability = try! Reachability()
    var urlSession: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let logo = UIImage(named: "logo");
        let imageView = UIImageView(image: logo);
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView;
        
        trendsListData.append("asdfa")
        trendsListData.append("adfaef")
        
        CirclesViewController.circlesDataList.append("game")
        CirclesViewController.circlesDataList.append("pe")
        CirclesViewController.circlesDataList.append("law")
        
        initUI()
        addPullToRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //视图已经出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("视图出现")
        self.initUI()
    }
    
    func initUI() {
        print("init UI")
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = 140
        //tableView.estimatedRowHeight = 140
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: 1))
        tableView.tableHeaderView = headerView
        //tableView.tableFooterView = headerView
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(FocusCirclesTableCell.self, forCellReuseIdentifier: "FocusCirclesTableCell")
        tableView.register(OneFocusCircleTableCell.self, forCellReuseIdentifier: "OneFocusCircleTableCell")
        tableView.register(LoadMoreTableCell.self, forCellReuseIdentifier: "LoadMoreTableCell")
        tableView.tableFooterView = UIView()
        
        tableView.setEditing(false, animated: false)
        self.view.addSubview(tableView)
    }
    
    @objc func receiverNotification(){
        let orient = UIDevice.current.orientation
        switch orient {
        case .portrait :
            print("屏幕正常竖向")
            break
        case .portraitUpsideDown:
            print("屏幕倒立")
            break
        case .landscapeLeft:
            print("屏幕左旋转")
            break
        case .landscapeRight:
            print("屏幕右旋转")
            break
        default:
            break
        }
        //self.tableView.frame = self.view.bounds
        //self.tableView.reloadData()
        self.initUI()
    }
    
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    
}

extension CirclesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
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
                cell.setViewController(vc: self)
                cell.setCirclesDateList(cirClesDateList: CirclesViewController.circlesDataList)
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
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OneFocusCircleTableCell", for: indexPath) as! OneFocusCircleTableCell
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
                return 80
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
            if indexPath.row == 0 {
                let destination = FocusCirclesViewController()
                destination.supervc = self
                //self.present(destination, animated: true, completion: nil)
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
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
