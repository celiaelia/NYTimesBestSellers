//
//  CategoriesTableViewController.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/9/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    //MARK: - Properties
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var fetchedResultsController: NSFetchedResultsController<Category>?
    
    var selectedCategory : Category?
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: - Create UIViewController extension to customize elements that are used in all Controllers
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.center = view.center;
        view.addSubview(activityIndicator)
        
        loadData()
    }
    
    func loadData() -> Void {
        //TODO: - Use the 'updateFrequency' field in Category to fetch the data again when NYTimes updates the list
        
        //First, we check if we have the data saved locally
        fetchedResultsController = ModelManager.sharedInstance.fetchBookCategories()
        
        //If not, we download it from server and save it
        if fetchedResultsController == nil || fetchedResultsController?.sections![0].numberOfObjects == 0 {
            activityIndicator.startAnimating()
            
            APIManager.sharedInstance.fetchAllBookCategories(completion: { [unowned self] result in
                self.activityIndicator.stopAnimating()
            
                if(result) {
                    self.fetchedResultsController = ModelManager.sharedInstance.fetchBookCategories()
                    self.tableView.reloadData()
                }
                else {
                    //TODO: - Use Reachability framework to know from the beginning if user has internet connection
                    let alert = UIAlertController(title: "Connection Problem", message: "Please make sure you are connected to the internet and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                        self.loadData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = fetchedResultsController else {
            fatalError("Application error no cell data available")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if let category = data.object(at:indexPath) as Category? {
            cell.textLabel?.text = category.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.accessoryType = .disclosureIndicator
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = fetchedResultsController?.object(at: indexPath)
        performSegue(withIdentifier: "BooksInCategory", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //This would go in the TODO of UIVIewController extension
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "BooksInCategory" {
            guard let controller = segue.destination as? BooksCollectionViewController else {
                fatalError("Storyboard mis-configuration. Controller is not of expected type BooksCollectionViewController")
            }
            
            controller.category = selectedCategory
        }
    }

}
