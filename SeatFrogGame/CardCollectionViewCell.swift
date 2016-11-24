//
//  CardCollectionViewCell.swift
//  SeatFrogGame
//
//  Created by Mitul Manish on 24/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    
    var cardShown: Bool = false
    
    var card: Card? {
        didSet {
            guard let card = card else {
                return
            }
            
            frontImage.image = card.image
        }
    }
    
    func showCard(show: Bool, animated: Bool) {
        frontImage.hidden = false
        backImage.hidden = false
        cardShown = show
        
        if animated {
            if show {
                UIView.transitionFromView(backImage,
                                          toView: frontImage,
                                          duration: 0.5,
                                          options: [.TransitionFlipFromRight, .ShowHideTransitionViews],
                                          completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transitionFromView(frontImage,
                                          toView: backImage,
                                          duration: 0.5,
                                          options: [.TransitionFlipFromRight, .ShowHideTransitionViews],
                                          completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubviewToFront(frontImage)
                backImage.hidden = true
            } else {
                bringSubviewToFront(backImage)
                frontImage.hidden = true
            }
        }
    }
}
