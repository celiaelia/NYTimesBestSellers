//
//  BooksCollectionViewController.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/10/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit
import CoreData

class BooksCollectionViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchedResultsController: NSFetchedResultsController<Book>?
    var category : Category?
    var selectedBook : Book?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0)
    fileprivate let itemsPerRow : CGFloat = 3
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category?.name
        
        loadData()
    }
    
    func loadData() -> Void {
        fetchedResultsController = ModelManager.sharedInstance.fetchBooksInCategory(category: category!)
        
        if fetchedResultsController == nil || fetchedResultsController?.sections![0].numberOfObjects == 0 {
            APIManager.sharedInstance.fetchBooksInCategory(categoryName: (category?.name)!, completion: { [unowned self] result in
                if(result) {
                    self.fetchedResultsController = ModelManager.sharedInstance.fetchBooksInCategory(category: self.category!)
                    self.collectionView.reloadData()
                }
                else {
                    let alert = UIAlertController(title: "Connection Problem", message: "Please make sure you are connected to the internet and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                        self.loadData()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                })
        }
    }
    
    //MARK: - IBAction Methods
    @IBAction func sortingValueChanged(_ sender: UISegmentedControl) {
        //TODO: - Save the user selection in NSUserDefaults
        
        let sortKey: String
        let ascending: Bool
        switch sender.selectedSegmentIndex
        {
        case 0:
            sortKey = "rank"
            ascending = true
        case 1:
            sortKey = "weeksBestSeller"
            ascending = false
        default:
            sortKey = ""
            ascending = false
        }
        fetchedResultsController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: ascending)]
        
        do {
            try fetchedResultsController?.performFetch()
            collectionView.reloadData()
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        let controller = segue.destination as! BookViewController
        controller.book = selectedBook
    }
}

// MARK:- UICollectionView DataSource

extension BooksCollectionViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (fetchedResultsController?.sections?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fetchedResultsController?.sections![section].objects?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell",for:indexPath) as! BookCoverCell
        let book = fetchedResultsController?.object(at: indexPath)
        
        if let imagePath = book?.coverImagePath {
            cell.imageView.imageFromUrl(urlString: imagePath)
        }
        
        cell.titleLabel.text = book?.title.capitalized
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension BooksCollectionViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBook = fetchedResultsController?.object(at: indexPath)
        performSegue(withIdentifier: "BookDetail", sender: nil)
    }
}

// MARK:- UICollectioViewDelegateFlowLayout methods

extension BooksCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

