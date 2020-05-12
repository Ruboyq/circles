//
//  MyCirclesCollectionCell.swift
//  circles
//
//  Created by lucien on 2020/5/11.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class FocusCircleSmallCollectionCell: UICollectionViewCell {
    
    var circle: String!
    var iconView: UIImageView!
    var titleLabel: UILabel!
    
    var vc: UIViewController!
    
    func initUI(vc: UIViewController)  {
        self.vc = vc
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true
        
        iconView = UIImageView()
        self.contentView.addSubview(iconView)
        iconView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.frame = CGRect(x: 10, y: iconView.frame.maxY, width: 60, height: 20)
        titleLabel.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(titleLabel)
        
        self.contentView.clipsToBounds = true
    }
    
    // UICollectionViewCell重写的属性
    override var isSelected: Bool {
        willSet {
            if newValue {
                print(circle ?? "")
                let destination = CirclesTrendsViewController()
                //self.present(destination, animated: true, completion: nil)
                //self.navigationController?.pushViewController(resume, animated: true)
                //vc.present(destination, animated: true, completion: nil)
                destination.circle = circle
                vc.navigationController?.pushViewController(destination, animated: true)
            } else {
                
            }
        }
    }
    
}

