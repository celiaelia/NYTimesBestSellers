//
//  ModelManager.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/9/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation
import CoreData

class ModelManager {
    
    // MARK - Categories Methods
    
    func saveBookCategory(name: String, displayName: String, updated: String) -> Void {
 
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: persistentContainer.viewContext) as! Category
        category.name = name
        category.displayName = displayName
        category.updateFrequency = 1
        
        saveContext()
    }
    
    func fetchBookCategories() -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let searchResults = try persistentContainer.viewContext.fetch(fetchRequest)
            return searchResults
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    //MARK - Books Methods
    func saveBook(title: String, author: String, summary: String, amazonLink: String?, reviewLink: String?, rank: Int32, weeksBestSeller: Int32, category: String) -> Void {
        
        let context = persistentContainer.viewContext
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context) as! Book
        
        book.title = title
        book.author = author
        book.amazonLink = amazonLink
        book.reviewLink = reviewLink
        book.rank = rank
        book.weeksBestSeller = weeksBestSeller
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", category)
        
        do {
            let searchResult = try context.fetch(fetchRequest).first
            book.category = searchResult
        } catch {
            print("Error with request: \(error)")
        }
        
        saveContext()
    }
    
    func fetchBooksInCategory(category: Category) -> [Book] {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        do {
            let searchResults = try persistentContainer.viewContext.fetch(fetchRequest)
            return searchResults
        } catch {
            print("Error with request: \(error)")
        }
        return []
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NYTimesBestSellers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
