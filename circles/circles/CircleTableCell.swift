//
//  CircleTableCell.swift
//  circles
//
//  Created by lucien on 2020/5/12.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class CircleTableCell: UITableViewCell {
    
    var circle: String!
    var imageview: UIImageView!
    var circleTextLabel: UILabel!
    var button: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageview = UIImageView()
        self.contentView.addSubview(imageview)
        imageview.frame = CGRect(x: UIScreen.main.bounds.width/2 - 40, y: 30, width: 80, height: 80)
        //设置圆形半径
        imageview.layer.cornerRadius = imageview.frame.size.width / 2
        //实现效果
        imageview.clipsToBounds = true
        
        circleTextLabel = UILabel()
        circleTextLabel.textColor = .black
        circleTextLabel.textAlignment = NSTextAlignment.center
        circleTextLabel.frame = CGRect(x: UIScreen.main.bounds.width/2 - 40, y: imageview.frame.maxY, width: 80, height: 30)
        self.contentView.addSubview(circleTextLabel)
        
        
        // 创建一个常规的button
        button = UIButton(type: .custom)
        button.frame = CGRect(x: UIScreen.main.bounds.width/2 - 40, y: circleTextLabel.frame.maxY+5, width: 80, height: 30)
        button.setTitle("已关注", for: .normal)
        //字体
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        //设置圆角
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        //设置边框
        //button.layer.borderColor = UIColor.black.cgColor
        //button.layer.borderWidth = 1.5
        //button.set
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        //无参数点击事件
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        //带button参数传递
        //button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        
        self.contentView.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //无参数点击事件
    @objc func buttonClick(){
          print("点击了button")
    }
    
    //带参数点击事件
    @objc func buttonClick2(button:UIButton ){
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.setTitle("Selected", for: .normal)
        }else{
            button.setTitle("NoSelected", for: .normal)
        }
    }
    
}
