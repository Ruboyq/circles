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
    
    var supervc: CirclesViewController!
    var refreshControl: UIRefreshControl!
    
    var api: ApiDataUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editAction))
        api = ApiDataUtil.init()
        initUI()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func initUI() {
        circlesDataList = ApiDataUtil.circlesDataList
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = 140
        //tableView.estimatedRowHeight = 140
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 1))
        tableView.tableHeaderView = headerView
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(OneFocusCircleTableCell.self, forCellReuseIdentifier: "OneFocusCircleTableCell")
        tableView.register(AllCirclesTableCell.self, forCellReuseIdentifier: "AllCirclesTableCell")
        tableView.tableFooterView = UIView()
        
        tableView.setEditing(false, animated: false)
        self.view.addSubview(tableView)
        addPullToRefresh()
    }
    
    @objc func receiverNotification(){
        //self.supervc.initUI()
        self.initUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initUI()
    }
    
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh3(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新中")
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh3(_ sender: UIRefreshControl) {
        print("pull refresh")
        self.api.initOrRefreshData(vc: self)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            DispatchQueue.main.async {
                self.circlesDataList = ApiDataUtil.circlesDataList
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
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
                cell.textLabel?.text = "我关注的圈子"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
                //cell.selectionStyle = .default
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OneFocusCircleTableCell", for: indexPath) as! OneFocusCircleTableCell
                let imageName = ApiDataUtil.circlesMap[circlesDataList[indexPath.row-1]] ?? ""
                cell.imageview.image = UIImage(named: imageName+"_n")
                cell.circleTextLabel.text = circlesDataList[indexPath.row-1]
                cell.numTextLabel.text = (ApiDataUtil.userNumCirclesMap[circlesDataList[indexPath.row-1]]?.description ?? "0")+"人关注"
                cell.vc = self
                cell.circle = circlesDataList[indexPath.row-1]
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
                let cell =  tableView.dequeueReusableCell(withIdentifier: "AllCirclesTableCell", for: indexPath) as! AllCirclesTableCell
                cell.setViewController(vc: self)
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
                let inOrient = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                if inOrient?.isPortrait ?? true {
                    return UIScreen.main.bounds.width*4/3-70
                } else {
                    return UIScreen.main.bounds.width*4/5+50
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print(indexPath.row)
        if indexPath.section == 0 {
            if indexPath.row > 0 {
                let destination = CirclesTrendsViewController()
                destination.circle = circlesDataList[indexPath.row-1]
                self.navigationController?.pushViewController(destination, animated: true)
            }
        }
    }
    
}

