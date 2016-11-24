//
//  Card.swift
//  SeatFrogGame
//
//  Created by Mitul Manish on 24/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    var id: Int!
    var cardShown: Bool = false
    var image: UIImage!
    
    init(id: Int, image: UIImage) {
        self.id = id
        self.image = image
    }
    
    init(card: Card) {
        self.id = card.id
        self.cardShown = card.cardShown
        self.image = card.image.copy() as! UIImage
    }
    
    func cardsEqual(card: Card) -> Bool {
        return card.id == self.id
    }
}
