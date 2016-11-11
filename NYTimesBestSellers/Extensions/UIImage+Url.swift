//
//  UIImage+Url.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/11/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit

extension UIImageView {
    //TODO: - Use NSCache to avoid downloading the same image multiple times
    
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                if let data = data {
                     DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}
