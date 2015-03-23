//
//  BookmarkCardFactory.swift
//  RolyPolySwift
//
//  Created by Dmitry Fedoseev on 22.03.15.
//  Copyright (c) 2015 Dmitry Fedoseev. All rights reserved.
//

import Foundation
import UIKit

class BookmarkCardProxy : NSObject {
    @IBOutlet var productName: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var shopName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var rating: UIImageView!
    @IBOutlet var numberOfRatings: UILabel!

}

////////////////////////////////////////////////////////////////////////////

class BookmarkCardFactory : NSObject {
    
    class func createBookmarkCardFromBookmark(bookmark: Bookmark) -> UIView {
        
        var proxy = BookmarkCardProxy()
        var bookmarkCard = NSBundle.mainBundle().loadNibNamed("BookmarkCardView", owner: proxy, options: nil)[0] as UIView
        
        proxy.productName.text = bookmark.productName
        proxy.productImage.image = UIImage(named: bookmark.productImagePath)
        proxy.shopName.text = bookmark.shopName
        proxy.price.text = BookmarkCardFactory.currencyStringForPrice(bookmark.price)
        proxy.rating.image = UIImage(named: BookmarkCardFactory.starImagePathForRating(bookmark.rating))
        proxy.numberOfRatings.text = NSString(format: "(%d)", bookmark.numberOfRatings)
        
        bookmarkCard.layer.cornerRadius = 3
        bookmarkCard.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).CGColor
        bookmarkCard.layer.borderWidth = 1
        bookmarkCard.layer.rasterizationScale = UIScreen.mainScreen().scale
        bookmarkCard.layer.shouldRasterize = true
        
        return bookmarkCard
    }
    
    class func currencyStringForPrice(price: Int) -> String {
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        var numberAsString = numberFormatter.stringFromNumber(NSNumber(integer: price))
        if let tempNumberAsSting = numberAsString {
            return tempNumberAsSting
        } else {
            return ""
        }
    }
    
    class func starImagePathForRating(rating: Float) -> String {
        
        if rating < 0.5 {
            return "stars-0.png"
        }
            
        else if rating < 1 {
            return "stars-0.5.png"
        }
            
        else if (rating < 1.5) {
            return "stars-1.png"
        }
            
        else if (rating < 2) {
            return "stars-1.5.png"
        }
            
        else if (rating < 2.5) {
            return "stars-2.png"
        }
            
        else if (rating < 3) {
            return "stars-2.5.png"
        }
            
        else if (rating < 3.5) {
            return "stars-3.png"
        }
            
        else if (rating < 4) {
            return "stars-3.5.png"
        }
            
        else if (rating < 4.5) {
            return "stars-4.png"
        }
            
        else if (rating < 5) {
            return "stars-4.5.png"
        }
        return "stars-5.png"
    }
}