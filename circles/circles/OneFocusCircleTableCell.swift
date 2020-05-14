//
//  MyCirclesTableCell.swift
//  circles
//
//  Created by lucien on 2020/5/11.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class OneFocusCircleTableCell: UITableViewCell {
    
    var circle: String!
    var imageview: UIImageView!
    var circleTextLabel: UILabel!
    var button: UIButton!
    var vc: UIViewController!
    
    var api: ApiDataUtil!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        api = ApiDataUtil()
        api.initUtil()
        
        imageview = UIImageView()
        self.contentView.addSubview(imageview)
        imageview.frame = CGRect(x: 25, y: 5, width: 50, height: 50)
        //设置圆形半径
        //imageview.layer.cornerRadius = imageview.frame.size.width / 2
        //实现效果
        //imageview.clipsToBounds = true
        
        circleTextLabel = UILabel()
        circleTextLabel.textColor = .black
        circleTextLabel.frame = CGRect(x: imageview.frame.maxX + 20, y: 5, width: 60, height: 50)
        self.contentView.addSubview(circleTextLabel)
        
        // 创建一个常规的button
        button = UIButton(type: .custom)
        //print(self.superview?.frame.width)
        
        //let inOrient = UIApplication.shared.statusBarOrientation
        let inOrient = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        if inOrient?.isPortrait ?? true {
            button.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 15, width: 70, height: 30)
        } else {
            button.frame = CGRect(x: UIScreen.main.bounds.width - 160, y: 15, width: 70, height: 30)
        }
        
        //button.frame = CGRect(x: UIScreen.main.bounds.width - 140, y: 15, width: 70, height: 30)
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
        print("点击了button:\(String(describing: circle))")
        api.deleteCircle(vc: vc, circle: circle)
    }
}
