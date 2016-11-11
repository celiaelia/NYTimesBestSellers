//
//  BookViewController.swift
//  NYTimesBestSellers
//
//  Created by Macarena on 11/10/16.
//  Copyright © 2016 Celia. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var coverTitleLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var amazonLinkLabel: UILabel!
    
    @IBOutlet weak var reviewLinkLabel: UILabel!
    
    @IBOutlet weak var amazonView: UIView!
    
    @IBOutlet weak var reviewView: UIView!
    
    var book : Book?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = book?.title.capitalized
        coverTitleLabel.text = book?.title.capitalized
        authorLabel.text = book?.author
        descriptionLabel.text = book?.summary
        
        //TODO: - Fix the layout for escenarios when some elemens are not presented
        if book?.amazonLink != "" {
            amazonLinkLabel.text = book?.amazonLink
        }
        else {
            amazonView.isHidden = true
        }
        if book?.reviewLink != "" {
            reviewLinkLabel.text = book?.reviewLink
        }
        else {
            reviewView.isHidden = true
        }
        
        coverImageView.imageFromUrl(urlString: (book?.coverImagePath)!)
    }
}

