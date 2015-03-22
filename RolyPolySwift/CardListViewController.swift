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


    var dataSource: CardListDataSource?
    var delegate: CardListDelegate?
    
    var padding: CGFloat?
    var cardWidth: CGFloat?
    var defaultCardHeight: CGFloat?
    
    var numberOfCards: Int?
    var cardPositions: NSMutableArray?
    var cardHeights: NSMutableArray?
    var visibleCards: NSMutableDictionary?
    
    var slideDuration: CGFloat?
    var slideDelay: CGFloat?
    
    var indexOfFirstVisibleCard: Int?
    var indexOfLastVisibleCard: Int?
    var indexOfFurthestVisitedCard: Int?
    
    var isScrollingProgrammatically: Bool
    
    // MARK: - Default Initializer
    
    convenience init(dataSource: CardListDataSource, delegate: CardListDelegate) {
        self.init()
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
        
        while self.shouldIncrementIndexOfLastVisibleCard
    }
    
    // MARK: - Loading and Unloading Cards
    
    func loadInitiallyVisibleCards() {
        self.loadCardAtIndex(self.indexOfLastVisibleCard, true)
        
        let delay = 0.3
        
        while
    }
    
    func loadCardAtIndex(index: Int, animated: Bool) {
        
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
    
    func slideCardOffScreeninDirection(card: UIView, direction: Direction, completion:block {
        
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
        
    }
    
    func frameForCardAtIndex(index: Int) -> CGRect {
        return CGRectMake(0, 0, 0, 0)
    }
}
