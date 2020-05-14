//
//  CommentCell.swift
//  circles
//
//  Created by yjp on 2020/5/13.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    lazy var headImage:UIImageView = {
    let headImage = UIImageView.init()
    headImage.contentMode = .scaleAspectFit
    return headImage
   }()
    lazy var nameLabel:UILabel = {
        let nameLabel = UILabel.init()
        nameLabel.textColor = BaseTool.UIColorRGB_Alpha(R: 202, G: 83, B: 128, alpha: 1)
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.gray;
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        return timeLabel
    }()
    lazy var textView: SLTextView = {
        let textView = SLTextView()
        textView.textColor = UIColor.black;
        textView.isEditable = false;
        textView.isScrollEnabled = false;
//        textView.delegate = self
        //        textView.backgroundColor = UIColor.green
        //内容距离行首和行尾的内边距
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.zero
        //        textView.max
        return textView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUI() {
        self.contentView.addSubview(self.headImage)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.textView)
        self.headImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.width.equalTo(35)
        }
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headImage.snp.right).offset(5)
            make.top.equalTo(self.headImage.snp.top).offset(2)
            make.height.equalTo(20)
        }
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.headImage.snp.right).offset(5)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(2)
            make.height.equalTo(10)
        }
        self.textView.snp.makeConstraints { (make) in
            make.left.equalTo(self.headImage.snp.left)
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(self.headImage.snp.bottom).offset(15)
            //            make.bottom.equalTo(self.picsArray[0].snp.top).offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

