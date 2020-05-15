//
//  CirclesTrendsViewController.swift
//  circles
//
//  Created by lucien on 2020/5/12.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class CirclesTrendsViewController: UIViewController {
    
    var tableView: UITableView!
    var trendsListData: [String] = [String]()
    var circle: String!
    
    var refreshControl: UIRefreshControl!
    var api: ApiDataUtil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editAction))
        
        api = ApiDataUtil.init()
        
        self.initUI()
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func initUI() {
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.rowHeight = 140
        //tableView.estimatedRowHeight = 140
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 1))
        tableView.tableHeaderView = headerView
        //tableView.tableFooterView = headerView
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 10
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.register(CircleTableCell.self, forCellReuseIdentifier: "CircleTableCell")
        tableView.register(OneFocusCircleTableCell.self, forCellReuseIdentifier: "OneFocusCircleTableCell")
        tableView.tableFooterView = UIView()
        
        tableView.setEditing(false, animated: false)
        self.view.addSubview(tableView)
        addPullToRefresh()
    }
    
    @objc func receiverNotification(){
        self.initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        self.api.initOrRefreshData(vc: self)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension CirclesTrendsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            //return trendsListData.count
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "CircleTableCell", for: indexPath) as! CircleTableCell
            cell.imageview.image = UIImage(named: ApiDataUtil.circlesMap[circle] ?? "")
            cell.setCircle(circle: circle)
            cell.vc = self
            //cell.selectionStyle = .default
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "OneFocusCircleTableCell", for: indexPath) as! OneFocusCircleTableCell
            cell.circle = circle
            cell.imageView?.image = UIImage(named: String(circle))
            cell.numTextLabel.text = (ApiDataUtil.userNumCirclesMap[circle]?.description ?? "0")+"人关注"
            cell.circleTextLabel.text = circle
            //self.navigationController
            return cell
            
        }
    }
}

extension CirclesTrendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 100
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
