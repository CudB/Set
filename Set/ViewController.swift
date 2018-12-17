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
        updateViewFromModel()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.cornerRadius = 8.0
        }
    }
    
    private lazy var game = Set()

    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var addCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var remainingCardsLabel: UILabel!
    
    @IBAction func addCardsButton(_ sender: UIButton) {
        game.drawCards()
        updateViewFromModel()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game.startNewGame()
        updateViewFromModel()
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons.")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            
            // Only enable the button if it is needed to represent a drawn card
            if index >= game.drawnCards.count {
                disableButton(button: button)
            } else {
                enableButton(button: button)
                button.layer.borderColor = UIColor.black.cgColor
                let card = game.drawnCards[index]
                assignCardFace(to: button, from: card)
                
                // Gives a matched card a border color based on if it was just selected or if it was part of an incorrect match.
                for chosenIndex in game.chosenCardIndices {
                    if chosenIndex == index {
                        if !game.matched {
                            button.layer.borderWidth = 3.0
                            button.layer.borderColor = UIColor.blue.cgColor
                        } else if !game.successfulMatch {
                            button.layer.borderWidth = 3.0
                            button.layer.borderColor = UIColor.red.cgColor
                        }
                    }
                }
            }
        }
        scoreLabel.text = "SCORE: \(game.score.value)"
        remainingCardsLabel.text = "\(game.cards.count) CARDS IN DECK"
        
        // Disables addCardsButton if there are not enough cards in the deck or if there are 24 drawn cards.
        if game.cards.count < 1 || game.drawnCards.count == 24{
            addCardsButton.isEnabled = false
            addCardsButton.backgroundColor = #colorLiteral(red: 0.3998717944, green: 0.3998717944, blue: 0.3998717944, alpha: 0.3076305651)
        } else {
            addCardsButton.isEnabled = true
            addCardsButton.backgroundColor = #colorLiteral(red: 0.3744180799, green: 0.573108077, blue: 0.9730513692, alpha: 1)
        }
    }
    
    // Hides a button from view without using .hidden.
    private func disableButton(button: UIButton) {
        button.setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.isEnabled = false
        button.layer.borderWidth = 0
    }
    
    // Reveals a button from view without using .hidden.
    private func enableButton(button: UIButton) {
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.isEnabled = true
        button.layer.borderWidth = 1
    }

    // Assigns a face to each button using a card's attributes
    private func assignCardFace(to button: UIButton, from card: SetCard) {
        var symbol: String
        var color: UIColor
        var attributes: [NSAttributedString.Key:Any]
        
        switch card.symbol {
        case .circle:
            symbol = "●"
        case .square:
            symbol = "■"
        case .triangle:
            symbol = "▲"
        }
        
        switch card.number {
        case .one:
            break
        case .two:
            symbol = repeatString(string: symbol, for: 2)
        case .three:
            symbol = repeatString(string: symbol, for: 3)
        }
        
        switch card.color {
        case .red:
            color = UIColor.red
        case .green:
            color = UIColor.green
        case .blue:
            color = UIColor.blue
        }
        
        switch card.shading {
        case .open:
            attributes = [
                .strokeWidth: 5.0,
                .strokeColor: color
            ]
        case .solid:
            attributes = [
                .foregroundColor: color
            ]
        case .striped:
            attributes = [
                .foregroundColor: color.withAlphaComponent(0.15)
            ]
        }
        
        let attributedString = NSAttributedString(string: symbol, attributes: attributes)
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
    
    // Takes a string and repeats it count number of times
    private func repeatString(string: String, for count: Int) -> String {
        var repeatedString = string
        for _ in 1..<count {
            repeatedString += string
        }
        return repeatedString
    }
}

