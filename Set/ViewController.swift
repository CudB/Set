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
            button.layer.cornerRadius = 8.0
            assignCardFace(to: button, from: card)
            if highlighted[card] == true {
                button.layer.borderWidth = 3.0
                button.layer.borderColor = UIColor.blue.cgColor
            } else {
                
                button.layer.borderWidth = 0
            }
        }
    }
    
    private func assignCardFace(to button: UIButton, from card: SetCard) {
        var shape: String
        var color: UIColor
        var attributes: [NSAttributedString.Key:Any]
        
        switch card.shape {
        case .circle:
            shape = "●"
        case .square:
            shape = "■"
        case .triangle:
            shape = "▲"
        }
        
        switch card.number {
        case .one:
            break
        case .two:
            shape = repeatChar(shape, count: 2)
        case .three:
            shape = repeatChar(shape, count: 3)
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

