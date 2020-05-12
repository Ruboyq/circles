//
//  LoadMoreTableCell.swift
//  circles
//
//  Created by lucien on 2020/5/11.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class LoadMoreTableCell: UITableViewCell {
    
    var loadingView: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        loadingView = UIActivityIndicatorView(style: .gray)
        self.contentView.addSubview(loadingView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.center = self.contentView.center
    }
    
}
