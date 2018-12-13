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
        updateViewFromModel()
    }
    
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
            assignCardFace(to: button, from: card)
            if highlighted[card] == true {
                button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                button.backgroundColor = #colorLiteral(red: 0.3744180799, green: 0.573108077, blue: 0.9730513692, alpha: 1)
            }
        }
    }
    
    private func assignCardFace(to button: UIButton, from card: SetCard) {
        var shape: String
        var color: UIColor
        var number: Int
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        ]
        
        switch card.shape {
        case .circle:
            shape = "●"
        case .square:
            shape = "■"
        case .triangle:
            shape = "▲"
        }
        
        switch card.number {
        case .two:
            shape = repeatChar(shape, count: 2)
        case .three:
            shape = repeatChar(shape, count: 3)
        default:
            break
        }
        
//        switch card.color {
//        case .red:
//
//        }
        
        let attributedString = NSAttributedString(string: shape, attributes: attributes)
        button.setAttributedTitle(attributedString, for: UIControl.State.normal)
        
    }
    
    func chooseCard(at card: SetCard) {
        if highlighted[card] == true {
            highlighted[card] = false
        } else {
            highlighted[card] = true
        }
    }
    
    private func repeatChar(_ char: String, count: Int) -> String {
        var repeatedString = char
        for _ in 1..<count {
            repeatedString += char
        }
        return repeatedString
    }
    
    private var highlighted = [SetCard:Bool]()
    
    
    
    
    
}

