import UIKit

class CirclesViewController: UIViewController {
    
    var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var isLoading: Bool = false
    
    var api: ApiDataUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let logo = UIImage(named: "logo");
        let imageView = UIImageView(image: logo);
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView;
        
        api = ApiDataUtil.init()
        api.initOrRefreshData(vc: self)
        
        initUI()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //通过使用通知中心，实现监听和处理程序退出事件的功能
        //获得一个应用实例。应用实例的核心作用是提供程序运行期间的控制和协作。每个程序必有，有且只有一个
        let app = UIApplication.shared
        //通知中心是基础框架的子系统。向所有监听程序退出事件的对象广播消息
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething(_:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    
    //创建一个方法用来响应程序退出事件，使程序在退出之前保存用户数据
    @objc func doSomething(_ sender: AnyObject) {
        print("Saving data before exit.")
        //从coredata存储数据
        let dbUtil = DbUtil()
        dbUtil.writeFocusCircles(userName: "test", circlesDataList: ApiDataUtil.circlesDataList)
        dbUtil.writeUserNumCircles(userNumCirclesMap: ApiDataUtil.userNumCirclesMap)
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
        
        addPullToRefresh()
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
            return ApiDataUtil.trendsListData.count
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
                //cell.setCirclesDateList(cirClesDateList: ApiUtil.circlesDataList)
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
        self.api.initOrRefreshData(vc: self)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadMore() {
        print("loading")
//        if !isLoading {
//            print("loading more")
//            isLoading = true
//            DispatchQueue.global().async {
//                self.api.refreshMyCircles(vc: self, state: 2)
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
}
