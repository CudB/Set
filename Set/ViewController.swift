//
//  ViewController.swift
//  Set
//
//  Created by Andy Au on 2018-12-11.
//  Copyright © 2018 Standford University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Set()

    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            chooseCard(at: game.cards[cardNumber])
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons.")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if highlighted[card] == true {
                button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                button.backgroundColor = #colorLiteral(red: 0.3744180799, green: 0.573108077, blue: 0.9730513692, alpha: 1)
            }
        }
    }
    
    func chooseCard(at card: SetCard) {
        if highlighted[card] == true {
            highlighted[card] = false
        } else {
            highlighted[card] = true
        }
    }
    
    private var highlighted = [SetCard:Bool]()
    
    
    
    
    
}

