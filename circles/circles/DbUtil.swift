//
//  DbUtil.swift
//  circles
//
//  Created by lucien on 2020/5/15.
//  Copyright © 2020 group4. All rights reserved.
//

import UIKit
import CoreData

public class DbUtil {
    
    var appdelgt = AppDelegate()
    
    func readUserNumOfCircles() -> [String: Int] {
        let fetchRequest: NSFetchRequest = UserNumOfCircles.fetchRequest()
        do {
            let result = try appdelgt.persistentContainer.viewContext.fetch(fetchRequest)
            var userNumCirclesMap: [String: Int] = [String:Int]()
            for userNumOfCircles in result {
                if userNumOfCircles.circle?.isEmpty ?? true {
                    continue
                }
                userNumCirclesMap[userNumOfCircles.circle!] = Int(userNumOfCircles.userNum)
            }
            print("read UserNumOfCircles success")
            return userNumCirclesMap
        } catch let err {
            print("core data fetch all error:", err)
        }
        return [String: Int]()
    }
    
    func readFocusCircles(userName: String) -> [String] {
        let fetchRequest: NSFetchRequest = FocusCircles.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@", userName)
        //        fetchRequest.predicate = oldMan
        do {
            let result: [FocusCircles] = try appdelgt.persistentContainer.viewContext.fetch(fetchRequest)
            if result.count > 0 {
                let str: String = result[0].circlesList ?? ""
                print("----------coreData\(str)")
                let circlesDataList: [String] = str.components(separatedBy: ",")
                print(circlesDataList.joined(separator: ","))
                return circlesDataList
            }
            print("read FocusCircles success")
        } catch let err {
            print("core data fetch error:", err)
        }
        return [String]()
    }
    
    func writeUserNumCircles(userNumCirclesMap: [String: Int]) {
        //首先删除本地存储数据
        deleteAllUserNumCircles()
        //存储新数据
        for (key, value) in userNumCirclesMap {
            let userNumOfCircles = NSEntityDescription.insertNewObject(forEntityName: "UserNumOfCircles", into: appdelgt.persistentContainer.viewContext) as! UserNumOfCircles
            userNumOfCircles.circle = key
            userNumOfCircles.userNum = Int16(value)
        }
        appdelgt.saveContext()
        print("write UserNumOfCircles success: \(userNumCirclesMap)")
    }
    
    func writeFocusCircles(userName: String, circlesDataList: [String]) {
        //首先删除本地存储数据
        deleteAllFocusCircles()
        //存储新数据
        let focusCircles = NSEntityDescription.insertNewObject(forEntityName: "FocusCircles", into: appdelgt.persistentContainer.viewContext) as! FocusCircles
        focusCircles.userName = userName
        focusCircles.circlesList = circlesDataList.joined(separator: ",")
        appdelgt.saveContext()
        print("write FocusCircles success: \(userName):\(circlesDataList.joined(separator: ","))")
    }
    
    func deleteAllUserNumCircles() {
        let fetchRequest: NSFetchRequest = UserNumOfCircles.fetchRequest()
        do {
            let result = try appdelgt.persistentContainer.viewContext.fetch(fetchRequest)
            for userNumOfCircles in result {
                appdelgt.persistentContainer.viewContext.delete(userNumOfCircles)
            }
            appdelgt.saveContext()
            print("delete UserNumOfCircles success")
        } catch let err {
            print("core data fetch all error:", err)
        }
    }
    
    func deleteAllFocusCircles() {
        let fetchRequest: NSFetchRequest = FocusCircles.fetchRequest()
        do {
            let result = try appdelgt.persistentContainer.viewContext.fetch(fetchRequest)
            for focusCircles in result {
                appdelgt.persistentContainer.viewContext.delete(focusCircles)
            }
            appdelgt.saveContext()
            print("delete UserNumOfCircles success")
        } catch let err {
            print("core data fetch all error:", err)
        }
    }
    
}
