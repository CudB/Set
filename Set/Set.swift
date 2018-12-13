//
//  Set.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

struct Set {
    private(set) var cards = [SetCard]()
    private(set) var chosenCardIndices = [Int]()
    private let maxChosenCards = 3
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        outerLoop: if chosenCardIndices.count == 0 {
            chosenCardIndices.append(index)
        } else {
            for chosenIndex in chosenCardIndices.indices {
                // Unselect the chosen card if it has already been selected and break the loop early.
                if chosenCardIndices[chosenIndex] == index {
                    chosenCardIndices.remove(at: chosenIndex)
                    break outerLoop
                }
            }
            // Remove currently selected cards if the maximum allowed has already been selected before selecting a new one.
            if chosenCardIndices.count >= maxChosenCards {
                chosenCardIndices.removeAll()
            }
            chosenCardIndices.append(index)
        }
    }
    
    mutating func startNewGame() {
        sortCards(cards: &cards)
    }
    
    init() {
        // Create a complete deck of unique cards for a game of Set.
        for number in Number.allCases {
            for symbol in Symbol.allCases {
                for color in Color.allCases {
                    for shading in Shading.allCases {
                        let card = SetCard(number: number, symbol: symbol, color: color, shading: shading)
                        cards += [card]
                    }
                }
            }
        }
        startNewGame()
    }
}

// Sorts an array of SetCard by modifying the input.
private func sortCards(cards: inout [SetCard]) {
    var sortedCards = [SetCard]()
    for _ in 1...cards.count {
        sortedCards += [cards.remove(at: cards.count.arc4random)]
    }
    cards = sortedCards
}

// The following enums define possible card attributes.
enum Number: CaseIterable {
    case one, two, three
}
enum Symbol: CaseIterable {
    case triangle, circle, square
}
enum Color: CaseIterable {
    case red, green, blue
}
enum Shading: CaseIterable {
    case open, striped, solid
}
