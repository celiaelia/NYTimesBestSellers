//
//  APIManager.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/8/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
     private let kBaseURL = "https://api.nytimes.com/svc/books/v3"
    
     func fetchAllBookCategories(completion: @escaping (_ result: Bool) -> Void) {
        Alamofire.request(kBaseURL + "/lists/names.json")
            .validate()
            .responseJSON { (response) in
                if response.result.isSuccess, let data = response.data {
                    let json = JSON(data: data)
                    
                    for (_, category) in json["results"] {
                        let name = category["list_name"].stringValue
                        let displayName = category["display_name"].stringValue
                        let updated = category["updated"].stringValue
                        
                        ModelManager().saveBookCategory(name: name, displayName: displayName, updated: updated)
                    }
                    completion(true)
                }
                else {
                    completion(false)
                }
        }
    }
    
    func fetchBooksInCategory(categoryName: String, completion: @escaping (_ result:Bool) -> Void) {
        Alamofire.request(kBaseURL + "/lists.json", method: .get, parameters: ["list" : categoryName], encoding: URLEncoding.default, headers: nil)
            .responseJSON { (response) in
                if response.result.isSuccess, let data = response.data {
                    let json = JSON(data: data)
                    
                    for (_, book) in json["results"] {
                        let title = book["book_details"][0]["title"].stringValue
                        let author = book["book_details"][0]["author"].stringValue
                        let summary = book["book_details"][0]["description"].stringValue
                        let amazonLink = book["amazon_product_url"].stringValue
                        let reviewLink = book["reviews"][0]["book_review_link"].stringValue
                        let rank = book["rank"].int32
                        let weeksBestSeller = book["weeks_on_list"].int32
                       
                        ModelManager().saveBook(title: title, author: author, summary: summary, amazonLink: amazonLink, reviewLink: reviewLink, rank: rank!, weeksBestSeller: weeksBestSeller!, category: categoryName)
                    }
                    completion(true)
                }
                else {
                    completion(false)
                }
        }
    }
}
