//
//  GameDelegate.swift
//  SeatFrogGame
//
//  Created by Mitul Manish on 24/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func cardGameDidStart(game: GameBrain)
    func cardGame(game: GameBrain, showCards cards: [Card])
    func cardGame(game: GameBrain, hideCards cards: [Card])
    func cardGameDidEnd(game: GameBrain, elapsedTime: NSTimeInterval, cards: [Card], chance: Int)
    func cardGameStopped(game: GameBrain, cards: [Card])
}