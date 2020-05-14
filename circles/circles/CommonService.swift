//
//  CommonService.swift
//  circles
//
//  Created by lucien on 2020/5/14.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit

public class CommonService {
    static func showMsgbox(vc: UIViewController, _message: String, _title: String = "提示"){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        vc.present(alert, animated: true, completion: nil)
    }
}
