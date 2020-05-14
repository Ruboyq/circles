//
//  BaseTool.swift
//  circles
//
//  Created by yjp on 2020/5/13.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class BaseTool {
    static func UIColorRGB_Alpha(R:CGFloat, G:CGFloat, B:CGFloat, alpha:CGFloat) -> UIColor
    {
        let color = UIColor.init(red: (R / 255.0), green: (G / 255.0), blue: (B / 255.0), alpha: alpha);
        return color;
    }
}

