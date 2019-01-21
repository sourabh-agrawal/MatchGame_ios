//
//  ViewController.swift
//  matchGame
//
//  Created by sourabh agrawal on 16/01/19.
//  Copyright © 2019 sourabh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    
    // property that will take care of the no of card that has been flipped
    var firstFlippedCardIndex : IndexPath?
    
    // create timer object
    var timer:Timer?
    
    // how much time do i want to give to the user
    var milliSeconds:Float = 60 * 1000 // 10 seconds
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardArray = model.getCards()
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        //timer is getting stop every time user scrolls so fixing it
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    
    // this method is called when the view is presented to the user
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    
    @objc func timerElapsed(){
        
        milliSeconds -= 1
        
        //convert to seconds
        let seconds = String(format: "%.2f", milliSeconds/1000)
        
        //set the timer
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // when timer is <0
        if milliSeconds <= 0{
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // check if there are unmatched cards
            checkGameEnded()
        }
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    //    MARK: - UICollectionView protocol methods
    
    //    i have to declare methods of both protocols
    
    //    firstly declaring methods of UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    //    next method will create the new collectionViewCell and firstly it will try to reuse the existing one but if that is not present then it will create a new one
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // get the card
        let card = cardArray[indexPath.row]
        
        // call the setCard method to keep control of the card
        cell.setCard(card)
        
        // return the generated cell
        return cell
    }
    
    //    next method is for when user select a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check if there is no time left
        if milliSeconds<=0 {
            return
        }
        
        
        // get the cell that user has sellected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // get the card that user has sellected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            // flip the card
            cell.flipCard()
            
            //play the flip sound
            SoundManager.playSound(.flip)
            
            // set the status of the card
            card.isFlipped = true
            
        }else{
            //flip the card
            cell.flipBack()
            
            // set the status of the card
            card.isFlipped = false
            
        }
        
        
        // determine if it is the first card or the second card that is being flipped over
        if firstFlippedCardIndex == nil{
//            print("it is the first card")
            //it is the first card so set the indexpath
            firstFlippedCardIndex = indexPath
        }else{
            
            
            // if user flipped the same card again then it's indexpath will be same as firstFlippedCardIndex
            if firstFlippedCardIndex == indexPath{
//                print("again flipped same card")
                // if user flipped back the first card itself then set it to nil again so that when next card gets sele
                firstFlippedCardIndex = nil
                return
            }
            
//            print("it is the second card")
            //it is the second card that is being flipped over
            // matching logic
            checkForMatchs(indexPath)
            
        }
        
    }
    
    // MARK:- game logic methods
    
    func checkForMatchs( _ secondFlippedCardIndex : IndexPath ){
        
        //get the cells of the two card that has been revealed
         let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        //get the cards that has been revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        
        //compare the two cards
        if cardOne.cardName == cardTwo.cardName{
            
            // it's  a match
            // play matched sound
            SoundManager.playSound(.match)
            
            //set the status of the card
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove the card from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // check if there are any card left
            checkGameEnded()
            
        }else{
            
            // it is not a match
            // play not matched sound
            SoundManager.playSound(.nomatch)
            
            //set the status of the card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            
            //flip both card back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            
        }
        
        // tell the collection view to reload the first card if it has been relocated and set to nil
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!]  )
        }
        
        //at the end reset firstFlippedCardIndex to nil so that user can start flipping of the card again
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded(){
        
        var isWon = true
        
        //check if there is unmatched cards
        for card in cardArray{
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        //message
        var title = ""
        var message = ""
        
        
        //if not then user has won the game and stop the timer
        if isWon == true {
            //stop the timer
            if milliSeconds > 0{
                timer?.invalidate()
            }
            title = "Congratulations!"
            message = "You've won"
            
            
        }else{
            // if there are unmatched cards then check if the timer is left
            if milliSeconds > 0{
                //there is time left so return
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        
        //show message
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}
