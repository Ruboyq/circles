////
////  CoreDataHandler.swift
////  circles
////
////  Created by yjp on 2020/5/13.
////  Copyright © 2020 group4. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class CoreDataHandler {
//    // MARK: - Core Data stack
//
//    lazy var oldMan: NSPredicate = {
//        return NSPredicate(format: "age > 30")
//    }()
//
//    
//    func fetchAll() -> [Resume] {
//        let fetchRequest: NSFetchRequest = Resume.fetchRequest()
////        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
//        do {
//            let result = try context.fetch(fetchRequest)
//            return result
//        } catch let err {
//            print("core data fetch all error:", err)
//        }
//        return [Resume]()
//    }
//    
//    func fetchResume(name: String) -> [Resume] {
//        let fetchRequest: NSFetchRequest = Resume.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
////        fetchRequest.predicate = oldMan
//        do {
//            let result: [Resume] = try persistentContainer.viewContext.fetch(fetchRequest)
//            print(result)
//            return result
//        } catch let err {
//            print("core data fetch error:", err)
//        }
//        return [Resume]()
//    }
//    
//    func fetchCount() {
//        let fetchRequest: NSFetchRequest = Resume.fetchRequest()
//        fetchRequest.resultType = .countResultType
//        do {
//            let result = try context.count(for: fetchRequest)
//            print("count: ", result)
//        } catch let err {
//            print("core data fetch all error:", err)
//        }
//    }
//    
//    func addResume(name: String, school: String, grade: String, img: String) {
//        let resume = NSEntityDescription.insertNewObject(forEntityName: "Resume", into: persistentContainer.viewContext) as! Resume
//        resume.name = name
//        resume.school = school
//        resume.grade = grade
//        resume.img = img
//        saveContext()
//    }
//    
//    func deleteAllResume() {
//        for tmp in fetchAll() {
//            context.delete(tmp)
//        }
//        saveContext()
//    }
//    
//    func deleteResume(name: String) {
//        for tmp in fetchResume(name: name) {
//            context.delete(tmp)
//        }
//        saveContext()
//    }
//
//    // MARK: - Core Data Property
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Resume")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    lazy var context = persistentContainer.viewContext
//    
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//}
//
