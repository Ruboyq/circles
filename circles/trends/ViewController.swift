//
//  ViewController.swift
//  SwiftStudy
//
//  Created by wsl on 2019/5/16.
//  Copyright © 2019 https://github.com/wsl2ls All rights reserved.
//

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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//        self.navigationItem.title = "One Piece"
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "ClearCache", style: UIBarButtonItem.Style.done, target: self, action: #selector(clearCache))
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
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
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
