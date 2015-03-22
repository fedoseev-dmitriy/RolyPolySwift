//
//  Bookmark.swift
//  RolyPolySwift
//
//  Created by Dmitry Fedoseev on 22.03.15.
//  Copyright (c) 2015 Dmitry Fedoseev. All rights reserved.
//

import Foundation

class Bookmark {
    var productName: String!
    var productImagePath: String!
    var shopName: String!
    var price: Int!
    var rating: Float!
    var numberOfRatings: Int!
    
    convenience init(productName: String, productImagePath: String, shopName: String,
        price: Int, rating: Float, numberOfRatings: Int) {
            self.init()
            self.productName = productName
            self.productImagePath = productImagePath
            self.shopName = shopName
            self.price = price
            self.rating = rating
            self.numberOfRatings = numberOfRatings
    }
    
}