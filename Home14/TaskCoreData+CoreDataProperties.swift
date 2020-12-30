//
//  TaskCoreData+CoreDataProperties.swift
//  Home14
//
//  Created by Maxim Chalikov on 22.12.2020.
//
//

import Foundation
import CoreData


extension TaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreData> {
        return NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var isCompleted: Bool

}

extension TaskCoreData : Identifiable {

}
