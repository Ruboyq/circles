//
//  User+CoreDataProperties.swift
//  
//
//  Created by mark on 2020/5/15.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var uid: String?
    @NSManaged public var username: String?
    @NSManaged public var sex: String?
    @NSManaged public var headImageStr: String?

}
