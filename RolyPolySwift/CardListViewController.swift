//
//  CardListViewController.swift
//  RolyPolySwift
//
//  Created by Dmitry Fedoseev on 22.03.15.
//  Copyright (c) 2015 Dmitry Fedoseev. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case Left
    case Right
}

@objc protocol CardListDataSourceProtocol {
    func numberOfCardsForCardList(cardList: CardListViewController) -> Int
    func cardForItemAtIndex(cardList: CardListViewController, index: Int) -> UIView
    func removeCardAtIndex(cardList: CardListViewController, index: Int)
    
    optional func heightForCardAtIndex(cardList: CardListViewController, index: Int) -> CGFloat
}

////////////////////////////////////////////////////////////////////////////

@objc protocol CardListDelegate {
    
}

////////////////////////////////////////////////////////////////////////////

class CardListViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {


    weak var dataSource: CardListDataSourceProtocol?
    weak var delegate: CardListDelegate?
    
    var padding: CGFloat? {
        return 25
    }
    var cardWidth: CGFloat? {
        return self.view.frame.size.width - 20
    }
    var defaultCardHeight: CGFloat? {
        return 250
    }
    var numberOfCards: Int? {
        return self.dataSource?.numberOfCardsForCardList(self)
    }
    lazy var cardPositions: NSMutableArray
    lazy var cardHeights: NSMutableArray
    lazy var visibleCards: NSMutableDictionary
    
    var slideDuration: CGFloat? {
        return 0.4
    }
    var slideDelay: CGFloat? {
        return 0.2
    }
    
    var indexOfFirstVisibleCard: Int?
    var indexOfLastVisibleCard: Int?
    var indexOfFurthestVisitedCard: Int?
    
    var isScrollingProgrammatically: Bool
    
    // MARK: - Default Initializer
    
    convenience init(dataSource: CardListDataSourceProtocol?, delegate: CardListDelegate?) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        self.view = scrollView
        
        self.loadInitiallyVisibleCards()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Scroll View Delegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.isScrollingProgrammatically || self.numberOfCards <= 0 {
            return
        }
        
        while self.shouldDecrementIndexOfFirstVisibleCard() {
            self.indexOfFirstVisibleCard -= 1
            self.loadCardAtIndex(self.indexOfFirstVisibleCard, false)
        }
        
        while self.shouldIncrementIndexOfFirstVisibleCard() {
            self.unloadCardAtIndex(self.indexOfFirstVisibleCard)
            self.indexOfFirstVisibleCard += 1
        }
        
        // update index of last visible card
        while self.shouldIncrementIndexOfLastVisibleCard() {
            self.indexOfLastVisibleCard += 1
            var animated = self.indexOfLastVisibleCard > self.indexOfFurthestVisitedCard
            self.loadCardAtIndex(self.indexOfLastVisibleCard, animated: animated)
        }
        
        while self.shouldDecrementIndexOfLastVisibleCard() {
            self.unloadCardAtIndex(self.indexOfLastVisibleCard)
            self.indexOfLastVisibleCard -= 1
        }

    }
    
    // MARK: - Loading and Unloading Cards
    
    func loadInitiallyVisibleCards() {
        self.loadCardAtIndex(self.indexOfLastVisibleCard!, true)
        
        let delay: CGFloat = 0.3
        
        while self.shouldIncrementIndexOfLastVisibleCard() {
            self.indexOfLastVisibleCard += 1
            var index = self.indexOfLastVisibleCard
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.loadCardAtIndex(index, animated: true)
                });
            delay += 0.3
        }
    }

    func loadCardAtIndex(index: Int, animated: Bool) {
        var card: UIView = self.dataSource!.cardForItemAtIndex(self, index: index)
        var width: CGFloat = self.cardWidth!
        var height: CGFloat = CGFloat(self.cardHeights!.objectAtIndex(index).floatValue)
        var x: CGFloat = self.view.center.x - width / 2
        var y: CGFloat = CGFloat(self.cardPositions!.objectAtIndex(index).floatValue)
        

        card.frame = CGRectMake(x, y, width, height)
        
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanFromRecognizer:")
        panRecognizer.delegate = self
        card.addGestureRecognizer(panRecognizer)
        
        var key = NSNumber(integer: index)
      
        self.visibleCards?.setObject(card, forKey: key)
        self.view.addSubview(card)
        
        if animated {
            self.slideCardIntoPlace(card)
        }
        
        if index > self.indexOfFurthestVisitedCard {
            self.indexOfFurthestVisitedCard = index;
        }

    }
    
    func unloadCardAtIndex(index: Int) {
        
    }
    
    func slideCardIntoPlace(card: UIView) {
        
    }
    
    // MARK: - Swipe To Delete Cards
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
    }
    
    func handlePanFromRecognizer(recognizer: UIPanGestureRecognizer) {
        
    }
    
    func angleForHorizontalOffset(horizontalOffset: CGFloat) -> CGFloat {
        
    }
    
    func alphaForHorizontalOffset(horizontalOffset: CGFloat) -> CGFloat {
        
    }
    
    func returnCardToOriginalState(card: UIView) {
        
    }
    
    func slideCardOffScreeninDirection(card: UIView, direction: Direction, completion:{ {
        
    }
    
    func deleteCard(card: UIView) {
        
    }
    
    func removeStateForCardAtIndex(index: Int) {
        
    }
    
    func updateVisibleCardsAfterCardRemovedFromIndex(index: Int) {
        
    }
    
    func makeScrollViewShorter() -> CGFloat {
        
    }
    
    func fillEmptySpaceLeftByCardAtIndex(index: Int) {
        
    }
    
    // MARK: - Card Visibility
    
    func shouldDecrementIndexOfFirstVisibleCard() -> Bool {
        
    }
    
    func shouldIncrementIndexOfFirstVisibleCard() -> Bool {
        
    }
    
    func shouldDecrementIndexOfLastVisibleCard() -> Bool {
        
    }
    
    func shouldIncrementIndexOfLastVisibleCard() -> Bool {
        
    }
    
    // MARK: - Helpers
    
    func createScrollView() -> UIScrollView {
        
    }
    
    func indexForVisibleCard(card: UIView) -> Int {
        var index = self.indexOfFirstVisibleCard
        
        while index < self.indexOfLastVisibleCard {
        var key: NSNumber = NSNumber(index)
        if self.visibleCards.objectForKey(key) == card {
        break
        }
        index++
        }
        return index
    }
    
    func frameForCardAtIndex(index: Int) -> CGRect {
        return CGRectMake(0, 0, 0, 0)
    }
}
