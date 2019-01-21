//
//  CardCollectionViewCell.swift
//  matchGame
//
//  Created by sourabh agrawal on 16/01/19.
//  Copyright © 2019 sourabh. All rights reserved.
//

import UIKit


class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card : Card?
    
    func setCard(_ card :Card){
        
        //  keep track of the card
        self.card = card
        //        print(card.isMatched)
        
        if card.isMatched == true {
            //            print("card matched")
            // if the card has been matched then make the front and back Image view invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            // return from the statement and don't run the code below
            return
        }else{
            
            // if the card has not been matched then make them visible
            
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.cardName)
        
        //check if the card has been flipped or not
        if card.isFlipped == true{
            
            //make sure that the frontImageView is on the top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else{
            
            //make sure that the backImageView is on the top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    //    flip card from front to back
    func flipCard(){
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    //    flip card from back to front
    func flipBack(){
        
        // add some delay to the flip back metthod
        //        print("calling flip back method")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            // in the execute parameter i am going to pass the transition
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove(){
        //        print("remove method called")
        //remove both of the cards from being visible
        backImageView.alpha = 0
        
        // animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            // make the frontImageView invisible
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
}
