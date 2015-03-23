//
//  CardListDataSource.swift
//  RolyPolySwift
//
//  Created by Dmitry Fedoseev on 22.03.15.
//  Copyright (c) 2015 Dmitry Fedoseev. All rights reserved.
//

import Foundation
import UIKit

class CardListDataSource: CardListDataSourceProtocol {
    
    //--------------------------------------------------------------------------
    
    lazy var bookmarks: NSMutableArray = {
    
        let canonRebel = Bookmark(productName: "Canon EOS Rebel T4i", productImagePath: "canon-rebel.png", shopName: "New Egg", price: 80614, rating: 4.5, numberOfRatings: 756)
        
        let marketPlace = Bookmark(productName: "Marketplace 3.0", productImagePath: "marketplace.png", shopName: "Rakuten Books", price: 1802, rating: 5, numberOfRatings: 1)
        
        let basketball = Bookmark(productName: "NBA Game Ball", productImagePath: "basketball.png", shopName: "Jump USA", price: 9913, rating: 5, numberOfRatings: 84)
        
        let iphone = Bookmark(productName: "iPhone 5C", productImagePath: "iphone-5c.png", shopName: "Apple Inc.", price: 53457, rating: 4.5, numberOfRatings: 405)
        
        let espresso = Bookmark(productName: "Phillips Saeco", productImagePath: "phillips-saeco.png", shopName: "Sears", price: 63453, rating: 4, numberOfRatings: 245)
        
        let glove = Bookmark(productName: "Mizuno Pro Limited Edition", productImagePath: "baseball-glove.png", shopName: "Mizuno USA", price: 49565, rating: 5, numberOfRatings: 422)
        
        let baloons = Bookmark(productName: "Party Balloons", productImagePath: "balloons.png", shopName: "Party City", price: 1231, rating: 3, numberOfRatings: 27)
        
        let batman = Bookmark(productName: "Batman Utitility Belt", productImagePath: "batman-utility-belt.png", shopName: "Wayne Enterprises", price: 29991, rating: 5, numberOfRatings: 124)
        
        let chia = Bookmark(productName: "Mr. T Chia Pet", productImagePath: "chia-pet.png", shopName: "Walmart", price: 500, rating: 2, numberOfRatings: 833)
        
        let competitiveness = Bookmark(productName: "Competitiveness", productImagePath: "competitiveness.png", shopName: "Rakuten Books", price: 5231, rating: 4.5, numberOfRatings: 15)
        
        var tempBookmarks = NSMutableArray(array: [canonRebel, marketPlace, basketball, iphone, espresso, glove, baloons, batman, competitiveness, chia])
        
        return tempBookmarks
    }()
    
    //--------------------------------------------------------------------------
    
    lazy var cards: NSMutableArray = {
        var tempCards = NSMutableArray()
        for bookmark in self.bookmarks {
            var card: UIView = BookmarkCardFactory.createBookmarkCardFromBookmark(bookmark as Bookmark)
            tempCards.addObject(card)
        }
        return tempCards
    }()
    
    //--------------------------------------------------------------------------
    
    func numberOfCardsForCardList(cardList: CardListViewController) -> Int {
        return self.cards.count
    }
    
    //--------------------------------------------------------------------------

    func cardForItemAtIndex(cardList: CardListViewController, index: Int) -> UIView {
        return self.cards.objectAtIndex(index) as UIView
    }
    
    //--------------------------------------------------------------------------
    
    func removeCardAtIndex(cardList: CardListViewController, index: Int) {
        self.cards.removeObjectAtIndex(index)
    }
}