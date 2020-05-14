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
    var button: UIButton!
    var vc: UIViewController!
    
    var api: ApiDataUtil!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageview = UIImageView()
        self.contentView.addSubview(imageview)
        imageview.frame = CGRect(x: UIScreen.main.bounds.width/2 - 50, y: 30, width: 100, height: 100)
        //设置圆形半径
        //imageview.layer.cornerRadius = imageview.frame.size.width / 2
        //实现效果
        //imageview.clipsToBounds = true
        
        // 创建一个常规的button
        button = UIButton(type: .custom)
        button.frame = CGRect(x: UIScreen.main.bounds.width/2 - 40, y: imageview!.frame.maxY+5, width: 80, height: 30)
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
        
        //无参数点击事件
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        //带button参数传递
        //button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        
        api = ApiDataUtil()
        api.initUtil()
        
        self.contentView.clipsToBounds = true
    }
    func setCircle(circle: String) {
        self.circle = circle
        if ApiDataUtil.circlesDataList.contains(circle) {
            button.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
            button.setTitle("已关注", for: .normal)
        } else {
            button.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
            button.setTitle("+关注", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //无参数点击事件
    @objc func buttonClick(){
        print("点击了button:\(String(describing: circle))")
        if ApiDataUtil.circlesDataList.contains(circle) {
            api.deleteCircle(vc: vc, circle: circle)
        } else {
            api.addCircle(vc: vc, circle: circle)
        }
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
