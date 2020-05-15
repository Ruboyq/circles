//
//  TrendTableCell.swift
//  circles
//
//  Created by lucien on 2020/5/15.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage
import GDPerformanceView_Swift
import Kingfisher

class TrendTableCell: UITableViewCell {
    //懒加载
    lazy var tableView : UITableView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
        let tableView = UITableView(frame: frame, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        //        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.allowsSelection = false
        tableView.register(SLTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.isScrollEnabled = false
        return tableView
    }()
    //中介 负责处理数据和事件
    var presenter : SLPresenter!
    static var dataArray = NSMutableArray()
    static var layoutArray = NSMutableArray()
    
    public static var uId:String?

    // MARK: UI
    func initTrendsCell(presenter : SLPresenter!) {
        self.presenter = presenter
        self.presenter.fullTextBlock = { (indexPath) in
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
    
        //限制内存高速缓存大小为50MB
        ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        //限制内存缓存最多可容纳150张图像
        ImageCache.default.memoryStorage.config.countLimit = 150
        
        let height = TrendTableCell.getFullHeight(layoutArray: TrendTableCell.layoutArray)
        self.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        self.contentView.addSubview(self.tableView)
        
        self.tableView.reloadData()
    }
    
    static func getFullHeight(layoutArray: NSMutableArray) -> CGFloat {
        var height: CGFloat = 0;
        for layout in layoutArray {
            //let layout : SLLayout = TrendTableCell.layoutArray[indexPath.row] as! SLLayout
            height += (layout as! SLLayout).cellHeight
        }
        return height+10
    }

    //安全距离什么时候被改变
//    override func viewSafeAreaInsetsDidChange() {
//        // 考虑安全距离
//        let insets: UIEdgeInsets = self.contentView.safeAreaInsets
//        print(insets)
//        self.tableView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.top.equalToSuperview().offset(insets.top)
//            make.bottom.equalToSuperview()
//        }
//    }
    
    // MARK: Events
    @objc func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            print("图片清除缓存完毕")
        }
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TrendTableCell : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrendTableCell.dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > TrendTableCell.layoutArray.count - 1 { return 0 }
        let layout : SLLayout = TrendTableCell.layoutArray[indexPath.row] as! SLLayout
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
        let model:SLModel = TrendTableCell.dataArray[indexPath.row] as! SLModel
        var layout:SLLayout?
        if indexPath.row <= TrendTableCell.layoutArray.count - 1 {
            layout = TrendTableCell.layoutArray[indexPath.row] as? SLLayout
        }
        cell.delegate = self.presenter
        cell.cellIndexPath = indexPath
        cell.configureCell(model: model, layout: layout)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
    }
}
