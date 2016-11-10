//
//  Category+CoreDataProperties.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/9/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var name: String
    @NSManaged public var updateFrequency: Int32
    @NSManaged public var displayName: String
    @NSManaged public var books: NSSet?

}

// MARK: Generated accessors for books
extension Category {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}
