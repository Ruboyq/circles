//
//  MyCirclesCollectionCell.swift
//  circles
//
//  Created by lucien on 2020/5/11.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class FocusCircleCollectionCell: UICollectionViewCell {
    
    var circle: String!
    var iconView: UIImageView!
    var titleLabel: UILabel!
    
    var vc: UIViewController!
    
    var sizeWH: Int!
    
    func initUI(vc: UIViewController)  {
        self.vc = vc
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true
        
        iconView = UIImageView()
        iconView.frame = CGRect(x: 5, y: 5, width: sizeWH-10, height: sizeWH-10)
        self.contentView.addSubview(iconView)
       
        self.contentView.clipsToBounds = true
    }
    
    // UICollectionViewCell重写的属性
    override var isSelected: Bool {
        willSet {
            if newValue {
                let destination = CirclesTrendsViewController()
                //self.navigationController?.pushViewController(resume, animated: true)
                //vc.present(destination, animated: true, completion: nil)
                destination.circle = circle
                vc.navigationController?.pushViewController(destination, animated: true)
            } else {
                
            }
        }
    }
    
}

