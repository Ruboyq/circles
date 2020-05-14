//
//  CommentModel.swift
//  circles
//
//  Created by yjp on 2020/5/13.
//  Copyright © 2020 group4. All rights reserved.
//
import Foundation

struct CommentModel: Codable {
    var uicon = ""
    var uname = ""
    var remark = ""
    var createTime = ""
    
    enum CodingKeys: CodingKey {
        case uicon
        case uname
        case remark
        case createTime
    }
}

struct CommentResponse: Codable {
    var msg: String = ""
    var data: [CommentModel] = [CommentModel]()
}
