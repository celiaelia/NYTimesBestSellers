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
    //MARK: - Shared Instance
    
    static let sharedInstance = ModelManager()
    
    var context: NSManagedObjectContext?
    
    //MARK: - Init
    
    private init() {
        if #available(iOS 10.0, *) {
            context = persistentContainer.viewContext
        } else {
            // iOS 9.0 and below
            guard let modelURL = Bundle.main.url(forResource: "NYTimesBestSellers", withExtension:"momd") else {
                fatalError("Error loading model from bundle")
            }
            guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
                fatalError("Error initializing mom from: \(modelURL)")
            }
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docURL = urls[urls.endIndex-1]
            let storeURL = docURL.appendingPathComponent("NYTimesBestSellers.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
            context?.persistentStoreCoordinator = psc
        }
    
    }
    
    // MARK: - Categories Methods
    
    func saveBookCategory(name: String, displayName: String, updated: String) -> Void {
 
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context!) as! Category
        category.name = name
        category.displayName = displayName
        //TODO: - Convert the frequency string to number of days: Weekly = 7...
        category.updateFrequency = 1

        saveContext()
    }
    
    func fetchBookCategories() -> NSFetchedResultsController<Category>? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<Category>(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    func fetchCategoryWithName(name: String) -> Category? {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let searchResults = try context!.fetch(fetchRequest).first
            return searchResults!
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    //MARK: - Books Methods
    func saveBook(title: String, author: String, summary: String, amazonLink: String?, reviewLink: String?, rank: Int32, weeksBestSeller: Int32, category: Category) -> Void {
        
        let book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context!) as! Book
        book.title = title
        book.author = author
        book.amazonLink = amazonLink
        book.reviewLink = reviewLink
        book.rank = rank
        book.weeksBestSeller = weeksBestSeller
        //This path is hardcoded since NYTimesBestSellers API doesn't provide an image link, added this one just for testing purposes
        book.coverImagePath = "http://lousybookcovers.com/wp-content/uploads/2014/03/cover_lg.jpg"
        book.category = category
        
        saveContext()
    }

    func fetchBooksInCategory(category: Category) -> NSFetchedResultsController<Book>? {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "category.name = %@", category.name)
        
        let fetchedResultsController = NSFetchedResultsController<Book>(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10, *)
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
        if context!.hasChanges {
            do {
                try context!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
