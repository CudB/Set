//
//  ViewController.swift
//  Set
//
//  Created by Andy Au on 2018-12-11.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Overrides the default UI colors to match the selected theme when the app is loaded.
    override func viewDidLoad() {
        newGameButton.layer.cornerRadius = 3.0
        addCardsButton.layer.cornerRadius = 3.0
        showSetButton.layer.cornerRadius = 3.0
        remainingCardsButton.layer.cornerRadius = 3.0
        remainingCardsButton.layer.borderWidth = 1.0
        remainingCardsButton.layer.borderColor = UIColor.black.cgColor
        remainingCardsButton.isEnabled = false
        updateViewFromModel()
    }
    
    private var game = Set() {
        didSet {
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var addCardsButton: UIButton!
    @IBOutlet weak var showSetButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var remainingCardsButton: UIButton!
    
    @IBOutlet weak var setCardGridView: SetCardGridView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(drawCards))
            swipe.direction = .up
            setCardGridView.addGestureRecognizer(swipe)
        }
    }
    
    @IBAction func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began:
            game.hand.shuffle()
            updateViewFromModel()
        default:
            break
        }
        
    }
    
    @objc func drawCards() {
        game.draw(amount: Set.CardLimits.cardsTakenPerDraw)
    }
    
    // Reveals a possible match to the player.
    @IBAction func showSetButton(_ sender: UIButton) {
//        if let setIndices = game.hand.cards.retrieveSetIndices {
//            for index in setIndices {
////                cardButtons[index].layer.borderWidth = 3.0
////                cardButtons[index].layer.borderColor = UIColor.green.cgColor
//            }
//            //TODO: Penalize player if a set is found.
//        } else {
//            //TODO: Display a message in the game to let the player know that there are no sets.
//            print("No sets present")
//        }
    }
    
    @IBAction func addCardsButton(_ sender: UIButton) {
        game.draw(amount: Set.CardLimits.cardsTakenPerDraw)
//        updateViewFromModel()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game.startNewGame()
//        updateViewFromModel()
    }
    
//    @IBAction func touchCard(_ sender: UIButton) {
//        if let cardNumber = cardButtons.index(of: sender) {
//            game.chooseCard(at: cardNumber)
//            updateViewFromModel()
//        } else {
//            print("Chosen card was not in cardButtons.")
//        }
//    }
    
    private func updateViewFromModel() {
        
        setCardGridView.cards = game.hand.cards
        
        
//        for index in cardButtons.indices {
//            let button = cardButtons[index]
//
//            // Only enable the button if it is needed to represent a drawn card
//            if index >= game.hand.cards.count {
//                disableCardButton(button: button)
//            } else {
//                enableCardButton(button: button)
//                button.layer.borderColor = UIColor.black.cgColor
//                let card = game.hand.cards[index]
//                assignCardFace(to: button, from: card)
//
//                // Gives selected cards a border.
//                for chosenIndex in game.chosenCardIndices {
//                    if chosenIndex == index {
//                        if !game.matchMade {
//                            // Border for selected cards.
//                            button.layer.borderWidth = 3.0
//                            button.layer.borderColor = UIColor.blue.cgColor
//                        } else if !game.successfulMatchMade {
//                            // Border for unsuccessful match.
//                            button.layer.borderWidth = 3.0
//                            button.layer.borderColor = UIColor.red.cgColor
//                        }
//                    }
//                }
//            }
//        }
        
        // Update labels with score and card count.
        scoreLabel.text = "SCORE: \(game.statistics.score)"
        remainingCardsButton.setTitle("\(game.deck.cards.count)", for: UIControl.State.normal)
        
        // Disables addCardsButton if there are not enough cards in the deck.
        if game.deck.cards.count < 1 {
            addCardsButton.isEnabled = false
            addCardsButton.alpha = 0.15
        } else {
            addCardsButton.isEnabled = true
            addCardsButton.alpha = 1
        }
    }
}

