//
//  ViewController.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/7/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager().fetchAllBookCategories(completion: { result in
            print("Success!");
            let categories = ModelManager().fetchBookCategories()
            for category in categories as [Category]{
                print(category.name);
            }
            APIManager().fetchBooksInCategory(categoryName: categories.first!.name, completion: { result in
                print("Success!")
            })
            })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

