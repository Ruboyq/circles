//
//  FocusCircleBigCollectionCell.swift
//  circles
//
//  Created by lucien on 2020/5/13.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class AllCirclesTableCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var vc: UIViewController!
    
    var margin: CGFloat!
    var sizeWH: CGFloat!
    var cirClesDateList: [String] = [String]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cirClesDateList = ["数码", "影视", "时尚", "体育", "校园", "亲子", "科学", "动漫", "游戏", "法律", "故事", "萌宠"]
        
        let inOrient = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if inOrient?.isPortrait ?? true {
            margin = 20
            sizeWH = UIScreen.main.bounds.width/3-30
        } else {
            margin = UIScreen.main.bounds.width/5-30
            sizeWH = UIScreen.main.bounds.width/5
        }
        
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.itemSize = CGSize(width: sizeWH, height: sizeWH)
        //行间距
        collectionLayout.minimumInteritemSpacing = 5
        //列间距
        collectionLayout.minimumLineSpacing = 5
        collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: margin, bottom: 0, right: margin)
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: sizeWH*4+30)
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        //注册cell或者叫item
        collectionView.register(FocusCircleCollectionCell.self, forCellWithReuseIdentifier: "FocusCircleCollectionCell")
        self.contentView.addSubview(collectionView)
        
        self.contentView.clipsToBounds = true
    }
    
    func setViewController(vc: UIViewController){
        self.vc = vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AllCirclesTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cirClesDateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FocusCircleCollectionCell", for: indexPath) as! FocusCircleCollectionCell
        cell.sizeWH = Int(sizeWH)
        cell.circle = cirClesDateList[indexPath.row]
        cell.initUI(vc: self.vc)
        cell.iconView.image = UIImage(named: ApiDataUtil.circlesMap[cirClesDateList[indexPath.row]] ?? "")
        return cell
    }

}

extension AllCirclesTableCell: UICollectionViewDelegate{
    
    
}
