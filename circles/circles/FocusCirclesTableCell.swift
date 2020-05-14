//
//  FocusCirclesTableCell.swift
//  circles
//
//  Created by lucien on 2020/5/12.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class FocusCirclesTableCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var scrollView: UIScrollView!
    var vc: UIViewController!
    
    var cirClesDateList: [String] = [String]()
    var widthOfCell: Int = 80
    var heightOfCell: Int = 80
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.itemSize = CGSize(width: widthOfCell, height: heightOfCell)
        //行间距
        collectionLayout.minimumInteritemSpacing = 5
        //列间距
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let rect = CGRect(x: 0, y: 0, width: widthOfCell * 13, height: heightOfCell)
        let collectionView = UICollectionView(frame: rect, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        //注册cell或者叫item
        collectionView.register(FocusCircleCollectionCell.self, forCellWithReuseIdentifier: "FocusCircleCollectionCell")
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.init(heightOfCell))) // Frame属性
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.init(heightOfCell)) // ContentSize属性
        scrollView.backgroundColor = .gray
        scrollView.bounces = false
        scrollView.indicatorStyle = .white
        scrollView.addSubview(collectionView)
        self.contentView.addSubview(scrollView)
        
        self.cirClesDateList = ApiDataUtil.circlesDataList
        self.scrollView.contentSize = CGSize(width: (widthOfCell+10) * (cirClesDateList.count+1), height: heightOfCell)
        
        self.contentView.clipsToBounds = true
        
    }
    
    func setViewController(vc: UIViewController){
        self.vc = vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FocusCirclesTableCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cirClesDateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FocusCircleCollectionCell", for: indexPath) as! FocusCircleCollectionCell
        cell.sizeWH = 80
        cell.initUI(vc: self.vc)
        cell.iconView.image = UIImage(named: ApiDataUtil.circlesMap[cirClesDateList[indexPath.row]] ?? "")
        cell.circle = cirClesDateList[indexPath.row]
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        //collectionView.reloadData()
//        print(indexPath.row)
//        print(cirClesDateList[indexPath.row])
//    }
}

extension FocusCirclesTableCell: UICollectionViewDelegate{
    
    
}
