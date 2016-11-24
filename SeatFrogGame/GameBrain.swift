//
//  GameBrain.swift
//  SeatFrogGame
//
//  Created by Mitul Manish on 24/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

class GameBrain {
    
    var chance: Int = 0
    var cards:[Card] = []
    private var cardsShown: [Card] = []
    var isPlaying: Bool = false
    var delegate: GameDelegate?
    var startTime: NSDate?
    
    
    var totalNumberOfCards: Int {
        get {
            return self.cards.count
        }
    }
    
    var totalTimeElapsed: NSTimeInterval {
        get {
            guard startTime != nil else {
                return -1
            }
            return NSDate().timeIntervalSinceDate(self.startTime!)
        }
    }
    
    func seedCards(images: [UIImage]) -> [Card] {
        
        var cards = [Card]()
        for i in 0...images.count-1 {
            let card = Card.init(id: i, image: images[i])
            cards.appendContentsOf([card, Card.init(card: card)])
        }
        cards.shuffle()
        return cards
    }
    
    func indexForCard(card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }
    
    func cardAtIndex(index: Int) -> Card? {
        if index < cards.count {
            return cards[index]
        }
        return nil
    }
    
    
    func startGame(images: [UIImage]) {
        self.cards = seedCards(images)
        self.startTime = NSDate()
        self.isPlaying = true
        delegate?.cardGameDidStart(self)
    }
    
    func stopGame() {
        abortGame()
        self.cards.removeAll()
        self.isPlaying = false
        self.startTime = nil
        self.cardsShown.removeAll()
    }
    
    
    func cardIsUnpaired() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    func getUnPairedCard() -> Card? {
        return cardsShown.last
    }
    
    
    
    func didSelectCard(card: Card?) {
        guard let card = card else {
            return
        }
        
        chance += 1
        // show the card to the user first
        delegate?.cardGame(self, showCards: [card])
        
        // check if there are any unpaired card available
        if cardIsUnpaired() {
            // fetch the unpaired card
            let unPairedCard = getUnPairedCard()
            // check if the card selected currently matches the unpaired card
            if unPairedCard!.cardsEqual(card) {
                // if yes add the currently selected card to the shown cards list
                cardsShown.append(card)
            } else {
                // if the currently selected card does match the unpaired card,remove both the cards(from the view) and also remove the
                // unpaired card from the shown cards list
                let unPairedCard = cardsShown.removeLast()
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.delegate?.cardGame(self, hideCards:[card, unPairedCard])
                }
            }
            
        }
            // if there are no unpaired cards then add the selected card to the card shown list
        else {
            cardsShown.append(card)
        }
        
        if allCardsDisplayed() {
            finishGame()
        }
    }
    
    private func finishGame() {
        isPlaying = false
        delegate?.cardGameDidEnd(self, elapsedTime: totalTimeElapsed, cards: cardsShown, chance: chance)
        flushCards()
    }
    
    func abortGame() {
        isPlaying = false
        delegate?.cardGameStopped(self, cards: cardsShown)
        flushCards()
    }
    
    func allCardsDisplayed() -> Bool {
        return cardsShown.count == cards.count
    }
    
    func flushCards() {
        cards.removeAll()
        cardsShown.removeAll()
    }
}

extension Array {
    //Randomizes the order of the array elements
    mutating func shuffle() {
        for _ in 1...self.count {
            self.sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}