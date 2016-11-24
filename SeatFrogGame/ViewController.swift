//
//  ViewController.swift
//  SeatFrogGame
//
//  Created by Mitul Manish on 24/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GameDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var gameBrain = GameBrain()
    var gameStarted: Bool = false
    var highestScore: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameBrain.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
     
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNewGame() {
        gameStarted = true
       
        let cardsData: [UIImage] = ImageFactory.defaultCardImages
        gameBrain.startGame(cardsData)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Laying out cells
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CardCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.showCard(false, animated: false)
        
        guard let card = gameBrain.cardAtIndex(indexPath.item) else {
            return cell
        }
        cell.card = card
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if gameStarted {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCollectionViewCell
            // if the card is already shown to the user simply return
            if cell.cardShown {
                return
            }
            gameBrain.didSelectCard(cell.card)
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        } else {
            let alertController = UIAlertController(title: "Want to play ?", message: "Press play button to start the game", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemWidth: CGFloat = CGRectGetWidth(collectionView.frame) / 3.0 - 15.0
        return CGSizeMake(itemWidth, itemWidth)
    }
    
    func cardGameDidStart(game: GameBrain) {
        collectionView.reloadData()
        collectionView.userInteractionEnabled = true
    }
    
    func cardGame(game: GameBrain, showCards cards: [Card]) {
        for card in cards {
            guard let index = gameBrain.indexForCard(card) else {
                continue
            }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! CardCollectionViewCell
            cell.showCard(true, animated: true)
        }
    }
    
    func cardGame(game: GameBrain, hideCards cards: [Card]) {
        for card in cards {
            guard let index = gameBrain.indexForCard(card) else {
                continue
            }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! CardCollectionViewCell
            cell.showCard(false, animated: true)
        }
    }
    
    
    func cardGameDidEnd(game: GameBrain, elapsedTime: NSTimeInterval, cards: [Card], chance: Int) {
        let ms = elapsedTime * 1000
        let seconds = Int(ms % 60)
        
        highestScore = returnHighestScore(seconds)
       
        gameStarted = false
        collectionView.userInteractionEnabled = false
        for card in cards {
            guard let index = gameBrain.indexForCard(card) else {
                continue
            }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! CardCollectionViewCell
            cell.showCard(false, animated: true)
            
        }
        
        collectionView.userInteractionEnabled = true
        let time = String(format: "%@: %.0fs", NSLocalizedString("TIME", comment: "time"), elapsedTime)
        let alertController = UIAlertController(title: "Score", message: "You took \(chance/2) chances and \(time) seconds to complete the game", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func cardGameStopped(game: GameBrain, cards: [Card]) {
        for card in cards {
            guard let index = gameBrain.indexForCard(card) else {
                continue
            }
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! CardCollectionViewCell
            cell.showCard(false, animated: true)
        }
        collectionView.userInteractionEnabled = false
        gameStarted = false
    }
    
    @IBAction func startButtonPressed(sender: UIBarButtonItem) {
        setupNewGame()
    }
    
    @IBAction func stopButtonPressed(sender: UIBarButtonItem) {
        if gameStarted {
            collectionView.userInteractionEnabled = false
            gameStarted = false
            let alertController = UIAlertController(title: "Abort Game", message: "Do you really want to abort the game?", preferredStyle: .Alert)
            let yesAction = UIAlertAction(title: "Yes", style: .Default) { (alertAction) in
                
                self.gameBrain.abortGame()
            }
            let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            presentViewController(alertController, animated: true, completion: nil)
        } 
    }
    
    func returnHighestScore(seconds: Int) -> Int? {
        var highest = 0
        if NSUserDefaults.standardUserDefaults().objectForKey("score") != nil {
            let previousScore = NSUserDefaults.standardUserDefaults().integerForKey("score")
            if previousScore > seconds {
                highest = previousScore
                NSUserDefaults.standardUserDefaults().setInteger(seconds, forKey: "score")
            } else {
                highest = seconds
            }
        } else {
            NSUserDefaults.standardUserDefaults().setInteger(seconds, forKey: "score")
            highest = seconds
        }
        return highest == 0 ? nil : highest
    }
    
    @IBAction func trophyButtonTouched(sender: UIBarButtonItem) {
        let score = NSUserDefaults.standardUserDefaults().integerForKey("score")
        let alertController = UIAlertController(title: "Highest Score", message: "Fastest time is \(score) seconds", preferredStyle: .ActionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

