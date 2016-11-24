//
//  ScoreKeeper.swift
//  SeatFrogGame
//
//  Created by Mitul Manish on 24/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation

struct ScoreKeeper {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    private var highestScore: Int? {
        get {
            return defaults.integerForKey("highestScore")
        }
        set {
            defaults.setInteger(newValue!, forKey: "highestScore")
        }
    }
    
    mutating func setOrEditHighestScore(currentScore: Int) -> Int? {
        if let previousHighestScore = highestScore {
            if currentScore > previousHighestScore {
                highestScore = currentScore
            }
        } else {
            highestScore = currentScore
        }
        return highestScore
    }
    
    
}