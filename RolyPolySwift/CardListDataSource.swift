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
    var bookmarks: NSMutableArray?
    var cards: NSMutableArray?
    
    
    func numberOfCardsForCardList(cardList: CardListViewController) -> Int {
        return self.cards!.count
    }

    func cardForItemAtIndex(cardList: CardListViewController, index: Int) -> UIView {
        return self.cards!.objectAtIndex(index) as UIView
    }
    
    func removeCardAtIndex(cardList: CardListViewController, index: Int) {
        self.cards!.removeObjectAtIndex(index)
    }
}