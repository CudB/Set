//
//  Set.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

struct Set {
    private let maxChosenCards = 3
    private let startingNumOfCards = 12
    private let maxNumberOfDrawnCards = 24
    private(set) var cards = [SetCard]()
    private(set) var drawnCards = [SetCard]()
    private(set) var chosenCardIndices = [Int]()
    private(set) var score = Score()
    private(set) var matched = false
    private(set) var successfulMatch = false

    mutating func chooseCard(at index: Int) {
        assert(drawnCards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        outerLoop: if chosenCardIndices.isEmpty {
            chosenCardIndices.append(index)
        } else {
            for chosenIndex in chosenCardIndices.indices {
                // Unselect the chosen card if it has already been selected and break the loop early.
                if chosenCardIndices[chosenIndex] == index && chosenCardIndices.count != maxChosenCards{
                    chosenCardIndices.remove(at: chosenIndex)
                    break outerLoop
                }
            }
            // Remove currently selected cards if the maximum allowed has already been selected before selecting a new one.
            chosenCardIndices.append(index)
            matched = false
            // Checks if a match occurs.
            if chosenCardIndices.count == maxChosenCards {
                matched = true
                
                // Checks if cards match successfully and applies a score bonus or penalty.
                if [drawnCards[chosenCardIndices[0]], drawnCards[chosenCardIndices[1]], drawnCards[chosenCardIndices[2]]].successfulMatch {
                    successfulMatch = true
                    score.increaseScore(by: 5)
                    
                    // Sorts the indices so the cards are removed from the deck in descending order to prevent any out of bound errors.
                    chosenCardIndices.sort(by: >)
                    for chosenCardIndex in chosenCardIndices {
                        assert(drawnCards.indices.contains(chosenCardIndex), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
                        drawnCards.remove(at: chosenCardIndex)
                    }
                    
                    // Replaces drawn cards if it drops below a certain number
                    if drawnCards.count < startingNumOfCards && cards.count >= 3 {
                        drawCards(amount: 3)
                    }
                } else {
                    score.decreaseScore(by: 10)
                    successfulMatch = false
                }
            } else if chosenCardIndices.count > maxChosenCards {
                chosenCardIndices.removeSubrange(0..<chosenCardIndices.count - 1)
            }
        }
    }
    
    mutating func drawCards(amount: Int) {
        assert(cards.count >= amount, "There aren't at least \(amount) cards to draw.")
        assert(drawnCards.count < maxNumberOfDrawnCards, "There are too many drawn cards.")
        for _ in 0..<amount {
            drawnCards.append(cards.removeFirst())
        }
    }
    
    mutating func startNewGame() {
        // Reset any variables that might have been modified during a game
        score.resetScore()
        matched = false
        successfulMatch = false
        chosenCardIndices.removeAll()
        
        // Set up a deck and draw cards
        cards = createSetDeck()
        sortCards(cards: &cards)
        drawnCards.removeAll()
        drawCards(amount: startingNumOfCards)
    }
    
    init() {
        startNewGame()
    }
}

// Create a complete deck of unique cards for a game of Set.
private func createSetDeck() -> [SetCard] {
    var deck = [SetCard]()
    for number in Number.allCases {
        for symbol in Symbol.allCases {
            for color in Color.allCases {
                for shading in Shading.allCases {
                    let card = SetCard(number: number, symbol: symbol, color: color, shading: shading)
                    deck += [card]
                }
            }
        }
    }
    return deck
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
