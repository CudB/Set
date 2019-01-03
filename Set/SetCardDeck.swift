//
//  SetCardDeck.swift
//  Set
//
//  Created by Andy Au on 2019-01-03.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation

struct SetCardDeck
{
    private(set) var cards = [SetCard]()
    
    init() {
        for number in SetCard.Number.allCases {
            for symbol in SetCard.Symbol.allCases {
                for color in SetCard.Color.allCases {
                    for shading in SetCard.Shading.allCases {
                        cards.append(SetCard(number: number, symbol: symbol, color: color, shading: shading))
                    }
                }
            }
        }
    }
    
    mutating func draw() -> SetCard {
        assert(cards.count > 0, "There are no cards to draw.")
        return cards.removeFirst()
    }
    
    mutating func draw(amount: Int) -> [SetCard] {
        assert(cards.count >= amount, "There are not enough cards to draw.")
        var drawnCards = [SetCard]()
        for _ in 0..<amount {
            drawnCards.append(cards.removeFirst())
        }
        return drawnCards
    }
    
    mutating func shuffle() {
        var sortedCards = [SetCard]()
        for _ in 1...cards.count {
            sortedCards += [cards.remove(at: cards.count.arc4random)]
        }
        cards = sortedCards
    }
}
