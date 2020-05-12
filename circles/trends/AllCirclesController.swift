//
//  AllCirclesController.swift
//  circles
//
//  Created by mark on 2020/5/12.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

class AllCirclesController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    public static var parentController: TrendsPublishController!
    
    var imgArray = [UIImageView]()
    
    @IBOutlet weak var pic0: UIImageView!
    
    @IBOutlet weak var pic1: UIImageView!
    
    @IBOutlet weak var pic2: UIImageView!
    
    @IBOutlet weak var pic3: UIImageView!
    
    @IBOutlet weak var pic4: UIImageView!
    
    @IBOutlet weak var pic5: UIImageView!
    
    @IBOutlet weak var pic6: UIImageView!
    
    @IBOutlet weak var pic7: UIImageView!
    
    @IBOutlet weak var pic8: UIImageView!
    
    @IBOutlet weak var pic9: UIImageView!
    
    @IBOutlet weak var pic10: UIImageView!
    
    @IBOutlet weak var pic11: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgArray.append(pic0)
        imgArray.append(pic1)
        imgArray.append(pic2)
        imgArray.append(pic3)
        imgArray.append(pic4)
        imgArray.append(pic5)
        imgArray.append(pic6)
        imgArray.append(pic7)
        imgArray.append(pic8)
        imgArray.append(pic9)
        imgArray.append(pic10)
        imgArray.append(pic11)
        for i in 0...11 {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            tap.name = String(i)
            imgArray[i].addGestureRecognizer(tap)
        }
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer) {
        let anotherCharacter: String = tap.name!
        switch anotherCharacter {
            case "0":
                TrendsPublishController.selectCircle = "校园"
                break
            case "1":
                TrendsPublishController.selectCircle = "动漫"
                break
            case "2":
                TrendsPublishController.selectCircle = "CHAO"
                break
            case "3":
                TrendsPublishController.selectCircle = "数码"
                break
            case "4":
                TrendsPublishController.selectCircle = "时尚"
                break
            case "5":
                TrendsPublishController.selectCircle = "游戏"
                break
            case "6":
                TrendsPublishController.selectCircle = "法律"
                break
            case "7":
                TrendsPublishController.selectCircle = "亲子"
                break
            case "8":
                TrendsPublishController.selectCircle = "体育"
                break
            case "9":
                TrendsPublishController.selectCircle = "科学"
                break
            case "10":
                TrendsPublishController.selectCircle = "故事"
                break
            case "11":
                TrendsPublishController.selectCircle = "影视"
                break
            default:
                TrendsPublishController.selectCircle = ""
        }
        AllCirclesController.parentController.changeCirle()
        self.dismiss(animated: true, completion:nil)
    }

}
