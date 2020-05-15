import UIKit
import SnapKit
import Alamofire
import AlamofireImage
import GDPerformanceView_Swift
import Kingfisher

class ViewController: UIViewController {
    //隐藏状态栏
    var isStatusBarHidden = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var prefersStatusBarHidden: Bool {
        get {
            return isStatusBarHidden
        }
    }
    //懒加载
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        //        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.allowsSelection = false
        tableView.register(SLTableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    //中介 负责处理数据和事件
    lazy var presenter : SLPresenter = {
        let presenter = SLPresenter()
        return presenter
    }()
    var dataArray = NSMutableArray()
    var layoutArray = NSMutableArray()
    var refreshControl: UIRefreshControl!
    public static var uId:String!
    @objc func showPublish(){
        let sb = UIStoryboard(name: "TrendsPublish", bundle: nil)
        let destination = sb.instantiateViewController(withIdentifier: "PublishView")
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: UI
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "logo");
        let imageView = UIImageView(image: logo);
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "trends_edit"), style: .plain, target: self, action: #selector(showPublish))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "trends_edit_blank"), style: .plain, target: self, action: nil)
        //性能监测工具
        //        PerformanceMonitor.shared().start()
        //中间者 处理数据和事件
        self.presenter.getData { (dataArray, layoutArray) in
            //            print("刷新")
            self.dataArray = dataArray
            self.layoutArray = layoutArray
            self.tableView.reloadData()
        }
        self.presenter.fullTextBlock = { (indexPath) in
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
        //限制内存高速缓存大小为50MB
        ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        //限制内存缓存最多可容纳150张图像
        ImageCache.default.memoryStorage.config.countLimit = 150
        setupUI()
        //通过使用通知中心，实现监听和处理程序退出事件的功能
        //获得一个应用实例。应用实例的核心作用是提供程序运行期间的控制和协作。每个程序必有，有且只有一个
        let app = UIApplication.shared
        //通知中心是基础框架的子系统。向所有监听程序退出事件的对象广播消息
        NotificationCenter.default.addObserver(self, selector: #selector(saveTrends(_:)), name: UIApplication.willResignActiveNotification, object: app)
    }
    //创建一个方法用来响应程序退出事件，使程序在退出之前保存用户数据
    @objc func saveTrends(_ sender: AnyObject) {
        print("Saving data before exit.")
        //从coredata存储数据
        let data = TrendCoreDataHandler()
        data.deleteAllTrends()
        
        self.dataArray.forEach { (item) in
            let model = item as! SLModel
            var images:String = ""
            for (index,image) in model.images.enumerated(){
                if index < model.images.count - 1 {
                    images = images+image+","
                }
                else if index == model.images.count - 1{
                    images = images+image
                }
            }
            data.addTrend(headPic: model.headPic, nickName: model.nickName!, time: model.time!, source: model.source!, title: model.title!, images: images, praiseNum: model.praiseNum!, commentNum: model.commentNum!, shareNum: model.shareNum!, isPraised: model.isPraised!, trendId: model.trendId!, uId: model.uId!, useuid: ViewController.uId!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //安全距离什么时候被改变
    override func viewSafeAreaInsetsDidChange() {
        // 考虑安全距离
        let insets: UIEdgeInsets = self.view.safeAreaInsets
        print(insets)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(insets.top)
            make.bottom.equalToSuperview()
        }
    }
    func setupUI() {
        self.view.addSubview(self.tableView)
        addPullToRefresh()
    }
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    // MARK: Events
    @objc func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            print("图片清除缓存完毕")
        }
    }
    
}

extension ViewController{
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        print("handleRefresh")
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
            self.presenter.getData { (dataArray, layoutArray) in
                //            print("刷新")
                self.dataArray = dataArray
                self.layoutArray = layoutArray
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}
// MARK: UITableViewDelegate, UITableViewDataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > self.layoutArray.count - 1 { return 0 }
        let layout : SLLayout = self.layoutArray[indexPath.row] as! SLLayout
        return layout.cellHeight
    }
    func tableView(_ tableVdiew: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SLTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SLTableViewCell
        let model:SLModel = self.dataArray[indexPath.row] as! SLModel
        var layout:SLLayout?
        if indexPath.row <= self.layoutArray.count - 1 {
            layout = self.layoutArray[indexPath.row] as? SLLayout
        }
        cell.delegate = self.presenter
        cell.cellIndexPath = indexPath
        cell.configureCell(model: model, layout: layout)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension UIViewController {
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
