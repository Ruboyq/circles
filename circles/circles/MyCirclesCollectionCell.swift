//
//  MyCirclesCollectionCell.swift
//  circles
//
//  Created by lucien on 2020/5/11.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class MyCirclesCollectionCell: UICollectionViewCell {
    
    var circle: String!
    var iconView: UIImageView!
    var titleLabel: UILabel!
    
    func initUI()  {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true
        
        iconView = UIImageView()
        self.contentView.addSubview(iconView)
        iconView.frame = CGRect(x: 0, y: 0, width: 75, height: 75)
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.frame = CGRect(x: 0, y: iconView.frame.maxY, width: 75, height: 20)
        titleLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(titleLabel)
        
        self.contentView.clipsToBounds = true
    }
    
    // UICollectionViewCell重写的属性
    override var isSelected: Bool {
        willSet {
            if newValue {
                print(circle ?? "")
            } else {
                
            }
        }
    }
    
}

