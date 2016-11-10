//
//  Book+CoreDataProperties.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/9/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation
import CoreData

extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var title: String
    @NSManaged public var author: String
    @NSManaged public var summary: String?
    @NSManaged public var amazonLink: String?
    @NSManaged public var reviewLink: String?
    @NSManaged public var rank: Int32
    @NSManaged public var weeksBestSeller: Int32
    @NSManaged public var coverImagePath: String?
    @NSManaged public var category: Category?

}
