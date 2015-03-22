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

@objc protocol CardListDataSourceProtocol  { //: NSObjectProtocol
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
    
    var padding: CGFloat! {
        return 25
    }
    var cardWidth: CGFloat! {
        return self.view.frame.size.width - 20
    }
    var defaultCardHeight: CGFloat! {
        return 250
    }
    
    lazy var numberOfCards: Int = { // note there may be a mistake
            return self.dataSource!.numberOfCardsForCardList(self)
    }()
    
    
    lazy var cardPositions: NSMutableArray = {
        var tempCardPositions = NSMutableArray()
        
        for var i = 0; i < self.numberOfCards; i++ {
            var position = Float(self.padding!)
            if i > 0 {
                var positionOfPreviousCard: NSNumber = tempCardPositions.objectAtIndex(i - 1) as NSNumber
                var heightOfPreviousCard: NSNumber = tempCardPositions.objectAtIndex(i - 1) as NSNumber
                
                position += positionOfPreviousCard.floatValue + heightOfPreviousCard.floatValue
            }
            tempCardPositions.addObject(NSNumber(float: position))
        }
        return tempCardPositions
    }()
    
    lazy var cardHeights: NSMutableArray = {
        var tempCardHeights = NSMutableArray()
        
        for var i = 0; i < self.numberOfCards; i++ {
            var height = Float(self.defaultCardHeight)
            
            if let tempDataSource = self.dataSource {
                if let methodHeightForCardAtIndex = tempDataSource.heightForCardAtIndex? {
                    height = Float(methodHeightForCardAtIndex(self, index: i))
                }
            }
            tempCardHeights.addObject(NSNumber(float: height))
        }
        return tempCardHeights
        
    }()

    
    
    lazy var visibleCards: NSMutableDictionary = {
        var tempVisibleCards = NSMutableDictionary()
        return tempVisibleCards
        
    }()
    
    var slideDuration: Double {
        return 0.4
    }
    var slideDelay: Double {
        return 0.2
    }
    
    var indexOfFirstVisibleCard: Int = Int()
    var indexOfLastVisibleCard: Int = Int()
    var indexOfFurthestVisitedCard: Int = Int()
    
    var isScrollingProgrammatically: Bool = Bool()
    
    
    
    // MARK: - Default Initializer
    override init () {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(dataSource: CardListDataSourceProtocol?, delegate: CardListDelegate?) {
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
            self.loadCardAtIndex(self.indexOfFirstVisibleCard, animated: false)
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
        self.loadCardAtIndex(self.indexOfLastVisibleCard, animated: true)
        
        var delay = 0.3
        
        while self.shouldIncrementIndexOfLastVisibleCard() {
            self.indexOfLastVisibleCard += 1
            var index = self.indexOfLastVisibleCard
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.loadCardAtIndex(index, animated: true)
            }
            
            delay += 0.3
        }
    }

    func loadCardAtIndex(index: Int, animated: Bool) {
        var card: UIView = self.dataSource!.cardForItemAtIndex(self, index: index)
        var width: CGFloat = self.cardWidth!
        var height: CGFloat = CGFloat(self.cardHeights.objectAtIndex(index).floatValue)
        var x: CGFloat = self.view.center.x - width / 2
        var y: CGFloat = CGFloat(self.cardPositions.objectAtIndex(index).floatValue)
        

        card.frame = CGRectMake(x, y, width, height)
        
        var panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanFromRecognizer:")
        panRecognizer.delegate = self
        card.addGestureRecognizer(panRecognizer)
        
        var key = NSNumber(integer: index)
      
        self.visibleCards.setObject(card, forKey: key)
        self.view.addSubview(card)
        
        if animated {
            self.slideCardIntoPlace(card)
        }
        
        if index > self.indexOfFurthestVisitedCard {
            self.indexOfFurthestVisitedCard = index;
        }

    }
    
    func unloadCardAtIndex(index: Int) {
        var key: NSNumber = NSNumber(integer: index)
        var card: UIView = self.visibleCards.objectForKey(key) as UIView
        
        self.visibleCards.removeObjectForKey(key)
        card.removeFromSuperview()
    }
    
    func slideCardIntoPlace(card: UIView) {
        var enterFromLeft = false
        enterFromLeft = !enterFromLeft
        
        var scrollView: UIScrollView = self.view as UIScrollView
        var yOffset = 200 + scrollView.contentOffset.y + scrollView.frame.size.height - card.frame.origin.y
        
        
        card.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, yOffset),CGAffineTransformMakeRotation(CGFloat(enterFromLeft ? M_PI/10 : -M_PI/10)))
        
        UIView.animateWithDuration(self.slideDuration, delay: self.slideDelay, options: .CurveEaseOut, animations: { () -> Void in
            card.transform = CGAffineTransformIdentity
            }, completion: nil)
        }
    
    // MARK: - Swipe To Delete Cards
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        var panRecognizer = gestureRecognizer as UIPanGestureRecognizer
        
        var translation = panRecognizer.translationInView(self.view)
        var x: CGFloat = translation.x
        var y: CGFloat = translation.y
        var slopeLessThanOneThird: Bool = fabs(y/x) < 1.0/3.0
        var slopeUndefined: Bool = x == 0 && y == 0
        return slopeLessThanOneThird || slopeUndefined
    }
    
    func handlePanFromRecognizer(recognizer: UIPanGestureRecognizer) {
        let deleteThreshold: CGFloat = 190.0
        
        var card: UIView = recognizer.view!
        
        var horizontalOffset: CGFloat = recognizer.translationInView(self.view).x

        var direction: Direction = horizontalOffset < 0 ? .Left : .Right
      
        var angle: CGFloat = self.angleForHorizontalOffset(horizontalOffset)
        var alpha: CGFloat = self.alphaForHorizontalOffset(horizontalOffset)
        
        card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(angle), CGAffineTransformMakeTranslation(horizontalOffset, 0))
        
        card.alpha = alpha;
        
        if recognizer.state == .Ended {
            if fabs(horizontalOffset) > deleteThreshold {
                self.slideCardOffScreeninDirection(card, direction: direction, completion: { (finished: Bool) -> Void in
                    self.deleteCard(card)
                })
            } else {
                self.returnCardToOriginalState(card)
            }
        }
    }
    
    func angleForHorizontalOffset(horizontalOffset: CGFloat) -> CGFloat {
        
        let rotationThreshold: CGFloat = 70
        
        var direction: CGFloat = horizontalOffset >= 0 ? 1.0 : -1.0
        var tempHorizontalOffset: CGFloat = fabs(horizontalOffset)
        
        if tempHorizontalOffset < rotationThreshold {
            return 0
        }
        
        var angle = (direction * (tempHorizontalOffset - rotationThreshold) * CGFloat((M_PI/1000)))
        return angle
    }
    
    func alphaForHorizontalOffset(horizontalOffset: CGFloat) -> CGFloat {
        let alphaThreshold: CGFloat = 70
        
        var tempHorizontalOffset: CGFloat = fabs(horizontalOffset);
        
        if (tempHorizontalOffset < alphaThreshold) {
            return 1.0;
        }
        
        var alpha = (CGFloat(pow(CGFloat(M_E), -pow(CGFloat((tempHorizontalOffset - alphaThreshold)/125), CGFloat(2)))));
        
        return alpha
    }
    
    func returnCardToOriginalState(card: UIView) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            card.transform = CGAffineTransformIdentity
            card.alpha = 1.0
            }, completion: nil)
        
    }
    
    func slideCardOffScreeninDirection(card: UIView, direction: Direction, completion:(finished: Bool) -> Void)
    {
        var finalOffset: CGFloat = 1.5 * self.view.frame.size.width
        if direction == .Left {
            finalOffset *= -1
        }
        var finalAngle: CGFloat = self.angleForHorizontalOffset(finalOffset)
        var finalAlpha: CGFloat = self.alphaForHorizontalOffset(finalOffset)
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(finalAngle),
            CGAffineTransformMakeTranslation(finalOffset, 0))
            card.alpha = finalAlpha
        }, completion: completion)
    }
    
    
    func deleteCard(card: UIView) {
        
        var index: Int = self.indexForVisibleCard(card)
        var oldCardPositions: NSMutableArray = NSMutableArray(array: self.cardPositions)
        oldCardPositions.removeObjectAtIndex(index)
        
        self.removeStateForCardAtIndex(index)
        var overlap: CGFloat = self.makeScrollViewShorter()
        
        if self.numberOfCards <= 0 {
            return
        }
        self.updateVisibleCardsAfterCardRemovedFromIndex(index)
        
        // put visible cards in their old positions
        
        for var visibleCardIndex: Int = self.indexOfFirstVisibleCard; visibleCardIndex <= self.indexOfLastVisibleCard; visibleCardIndex++ {
            var card: UIView = self.visibleCards.objectForKey(NSNumber(integer: visibleCardIndex)) as UIView
            var x: CGFloat = card.frame.origin.x
            var y: CGFloat = CGFloat((oldCardPositions.objectAtIndex(visibleCardIndex) as NSNumber).floatValue) - overlap
            var width: CGFloat = card.frame.size.width
            var height: CGFloat = card.frame.size.height
            card.frame = CGRectMake(x, y, width, height)
            
        }
        self.fillEmptySpaceLeftByCardAtIndex(index)
    }
    
    func removeStateForCardAtIndex(index: Int) {
        self.dataSource?.removeCardAtIndex(self, index: index)
        self.unloadCardAtIndex(index)
        self.numberOfCards--
        
        var removedCardHeight: CGFloat = CGFloat((self.cardHeights.objectAtIndex(index) as NSNumber).floatValue)
        self.cardHeights.removeObjectAtIndex(index)
        
        self.cardPositions.removeObjectAtIndex(index)
        for var i: Int = 0; i < self.cardPositions.count; i++ {
            var position = CGFloat((self.cardPositions.objectAtIndex(i) as NSNumber).floatValue)
            position -= removedCardHeight + self.padding
            var tempPosition = Double(position)
            self.cardPositions.replaceObjectAtIndex(i, withObject: NSNumber(double: tempPosition))
        }
        
        self.indexOfLastVisibleCard--
        
        var keysInOrder: NSArray = self.visibleCards.allKeys.sorted { ( a: AnyObject,  b: AnyObject) -> Bool in
            let c: NSNumber = a as NSNumber
            let d: NSNumber = b as NSNumber
            return c.doubleValue < d.doubleValue
        }
        
        for key in keysInOrder {
            var cardIndex: Int = key.integerValue
            if (cardIndex > index) {
                var card: UIView = self.visibleCards.objectForKey(key) as UIView
                self.visibleCards.removeObjectForKey(key)
                cardIndex--
                var newKey: NSNumber = NSNumber(integer: cardIndex)
                self.visibleCards.setObject(card, forKey: newKey)
            }
        }

    }
    
    func updateVisibleCardsAfterCardRemovedFromIndex(index: Int) {
        
        
        while self.shouldIncrementIndexOfFirstVisibleCard() {
            self.unloadCardAtIndex(self.indexOfFirstVisibleCard)
            self.indexOfFirstVisibleCard += 1;
        }
        
        while self.shouldDecrementIndexOfFirstVisibleCard() {
            self.indexOfFirstVisibleCard -= 1;
            self.loadCardAtIndex(self.indexOfFirstVisibleCard, animated:false)
        }
        
        while self.shouldIncrementIndexOfLastVisibleCard() {
            self.indexOfLastVisibleCard += 1;
            self.loadCardAtIndex(self.indexOfLastVisibleCard, animated:false)
        }
        
        while self.shouldDecrementIndexOfLastVisibleCard() {
            self.unloadCardAtIndex(self.indexOfLastVisibleCard)
            self.indexOfLastVisibleCard -= 1;
        }

    }
    
    func makeScrollViewShorter() -> CGFloat {
        
        var scrollView: UIScrollView = self.view as UIScrollView
        
        var bottomOfScrollView: CGFloat = scrollView.contentSize.height
        var bottomOfScreen: CGFloat = scrollView.contentOffset.y + scrollView.frame.size.height
        var bottomOfScreenToBottomOfScrollView: CGFloat = max(0, bottomOfScrollView - bottomOfScreen)
        
        var heightOfAllCards: CGFloat = 0
        
        for cardHeight in self.cardHeights {
            heightOfAllCards += CGFloat(cardHeight.floatValue)
        }
        var spaceLeftByRemovedCard: CGFloat = scrollView.contentSize.height - heightOfAllCards - CGFloat((self.numberOfCards + 1)) * self.padding
        
        var amountScrollViewHeightWillChange: CGFloat = min(scrollView.contentSize.height - scrollView.frame.size.height, spaceLeftByRemovedCard)

        var overlap: CGFloat = max(0, bottomOfScreen - (bottomOfScrollView - amountScrollViewHeightWillChange))
        
        // make scrollView shorter
        
        var removedRegionOverlapsVisibleRegion: Bool = bottomOfScreenToBottomOfScrollView < amountScrollViewHeightWillChange
       
        if removedRegionOverlapsVisibleRegion == true {
            self.isScrollingProgrammatically = true
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - overlap)
            self.isScrollingProgrammatically = false
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - amountScrollViewHeightWillChange)
        
        return overlap

    }
    
    func fillEmptySpaceLeftByCardAtIndex(index: Int) {
        
        var sortedKeys: NSArray = self.visibleCards.allKeys.sorted { (a: AnyObject, b: AnyObject) -> Bool in
            let c = a as NSNumber
            let d = b as NSNumber
            
            var distanceFromAToRemovedCard: NSNumber = NSNumber(integer: abs(c.integerValue - index))
            var distanceFromBToRemovedCard: NSNumber = NSNumber(integer: abs(d.integerValue - index))
            return distanceFromAToRemovedCard.doubleValue < distanceFromBToRemovedCard.doubleValue
        }
        
        var delay = 0.0
        
        for key in sortedKeys {
            var card: UIView = self.visibleCards.objectForKey(key) as UIView
            var oldPosition: CGFloat = card.frame.origin.y
            var newPosition: CGFloat = CGFloat((self.cardPositions.objectAtIndex(key.integerValue) as NSNumber).floatValue)
            var needsToBeMoved: Bool = oldPosition != newPosition
            
            if needsToBeMoved {
                card.frame = CGRectMake(card.frame.origin.x, newPosition, card.frame.size.width, card.frame.size.height)
                card.transform = CGAffineTransformMakeTranslation(0, oldPosition - newPosition)
                var duration = 0.5
                
                UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseInOut, animations: { () -> Void in
                    card.transform = CGAffineTransformIdentity
                    }, completion: nil)
                
                
                // rotation
                var angle: CGFloat = newPosition < oldPosition ? CGFloat(1*(M_PI/180)) : CGFloat(-1*(M_PI/180))
                var rotationAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.duration = Double(duration)
                rotationAnimation.beginTime = CACurrentMediaTime() + Double(delay) + 0.01
                rotationAnimation.calculationMode = kCAAnimationCubic
                rotationAnimation.values = [NSNumber(float: 0.0),
                    NSNumber(float: Float(angle)),
                    NSNumber(float: Float(angle)),
                    NSNumber(float: 0.0)]
                
                rotationAnimation.keyTimes = [NSNumber(float: 0.0),
                    NSNumber(float: 0.35),
                    NSNumber(float: 0.65),
                    NSNumber(float: 1.0)]
                
                card.layer.addAnimation(rotationAnimation, forKey: nil)
                delay += 0.2
            }
        }

    }
    
    // MARK: - Card Visibility
    
    func shouldDecrementIndexOfFirstVisibleCard() -> Bool {
        var scrollView = self.view as UIScrollView
        
        var positionOfFirstVisibleCard = self.cardPositions.objectAtIndex(self.indexOfFirstVisibleCard) as NSNumber
        
        var cardAboveIsVisible: Bool = CGFloat(positionOfFirstVisibleCard.doubleValue) - scrollView.contentOffset.y > self.padding
        

        var isFirstCardInList: Bool = self.indexOfFirstVisibleCard == 0
        
        return cardAboveIsVisible && !isFirstCardInList
    }
    
    func shouldIncrementIndexOfFirstVisibleCard() -> Bool {
        var scrollView = self.view as UIScrollView
        
        var positionOfFirstVisibleCard = self.cardPositions.objectAtIndex(self.indexOfFirstVisibleCard) as NSNumber
        var heightOfFirstVisibleCard = self.cardHeights.objectAtIndex(self.indexOfFirstVisibleCard) as NSNumber
        
        var cardIsNotVisible: Bool = CGFloat(positionOfFirstVisibleCard.doubleValue) + CGFloat(heightOfFirstVisibleCard.doubleValue) <= scrollView.contentOffset.y
        
        var isLastCardInList: Bool = self.indexOfFirstVisibleCard == self.numberOfCards - 1
        return cardIsNotVisible && !isLastCardInList
    }
    
    func shouldDecrementIndexOfLastVisibleCard() -> Bool {
        var scrollView = self.view as UIScrollView
        
        var positionOfLastVisibleCard = self.cardPositions.objectAtIndex(self.indexOfLastVisibleCard) as NSNumber
        
        var positionOfScreenBottom = scrollView.contentOffset.y + scrollView.frame.size.height
        
        var cardIsNotVisible: Bool = CGFloat(positionOfLastVisibleCard.doubleValue) > positionOfScreenBottom
        var isFirstCardInList: Bool = self.indexOfLastVisibleCard == 0
        
        return cardIsNotVisible && !isFirstCardInList
    }
    
    func shouldIncrementIndexOfLastVisibleCard() -> Bool {
        var scrollView = self.view as UIScrollView
        
        var positionOfLastVisibleCard = self.cardPositions.objectAtIndex(self.indexOfLastVisibleCard) as NSNumber
        
        var heightOfLastVisibleCard = self.cardHeights.objectAtIndex(self.indexOfLastVisibleCard) as NSNumber
        var positionOfScreenBottom = scrollView.contentOffset.y + scrollView.frame.size.height
        var positionOfCardBottom = CGFloat(positionOfLastVisibleCard.doubleValue + heightOfLastVisibleCard.doubleValue)
        
        var cardBelowIsVisble: Bool = positionOfScreenBottom - positionOfCardBottom > self.padding
        var isLastCardInList: Bool = self.indexOfLastVisibleCard == self.numberOfCards - 1
        
        return cardBelowIsVisble && !isLastCardInList
    }
        
    
    // MARK: - Helpers
    
    func createScrollView() -> UIScrollView {
        
        var fullScreenRect: CGRect = UIScreen.mainScreen().applicationFrame
        var scrollView = UIScrollView(frame: fullScreenRect)
        
        scrollView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1.0)
        scrollView.alwaysBounceVertical = true
        
        var contentWidth = UIScreen.mainScreen().applicationFrame.size.width
        var contentHeight: CGFloat = self.padding
        
        for cardHeight in self.cardHeights {
            contentHeight += self.padding
            contentHeight += CGFloat(cardHeight.doubleValue)
        }
   
        
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        
        return scrollView
    }
    
    func indexForVisibleCard(card: UIView) -> Int {
        var index: Int = self.indexOfFirstVisibleCard
        
        while index < self.indexOfLastVisibleCard {
            var key = NSNumber(integer: index)
            
            if self.visibleCards.objectForKey(key) as UIView == card {
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
