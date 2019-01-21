//
//  CardModel.swift
//  matchGame
//
//  Created by sourabh agrawal on 16/01/19.
//  Copyright © 2019 sourabh. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // temp array to hold the generate cards
        var tempArray = [Int]()
        
        // declare an array to store the generated cards
        var generatedArray = [Card]()
        
        // randomly generate pair of cards
        // i am going to make 8 pairs of cards
        while tempArray.count < 8 {
            
            // generate random card image number
            let randomNumber = arc4random_uniform(13) + 1
            
            // if it is a new number then only run the following statements
            if tempArray.contains(Int(randomNumber)) == false {
                
                print(randomNumber)
                // add in temp array also
                tempArray.append(Int(randomNumber))
                
                // create first card object
                let cardOne = Card()
                cardOne.cardName = "card\(randomNumber)"
                generatedArray.append(cardOne)
                
                //            create second card object
                let cardTwo = Card()
                cardTwo.cardName = "card\(randomNumber)"
                generatedArray.append(cardTwo)
            }
        }
        // randomize the cards in the array
        
        for i in 0...generatedArray.count-1 {
            
            // generate a random index number for swapping
            let randomNo = Int(arc4random_uniform(UInt32(generatedArray.count)))
            
            //perform swapping
            let tempCard = generatedArray[i]
            generatedArray[i] = generatedArray[randomNo]
            generatedArray[randomNo] = tempCard
        }
        
//        return the array
        return generatedArray
    }
    
}
