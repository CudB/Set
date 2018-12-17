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
    private(set) var cards = [SetCard]()
    private(set) var drawnCards = [SetCard]()
    private(set) var chosenCardIndices = [Int]()
    private(set) var score = Score()
    private(set) var matched = false
    private(set) var successfulMatch = false

    mutating func chooseCard(at index: Int) {
        assert(drawnCards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        outerLoop: if chosenCardIndices.count == 0 {
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
                if threeSetCardsMatchSuccessfully(drawnCards[chosenCardIndices[0]], drawnCards[chosenCardIndices[1]], drawnCards[chosenCardIndices[2]]) {
                    successfulMatch = true
                    score.increaseScore(by: 5)
                    
                    // Sorts the indices so the cards are removed from the deck in descending order to prevent any out of bound errors.
                    chosenCardIndices.sort(by: >)
                    for chosenCard in chosenCardIndices {
                        assert(drawnCards.indices.contains(chosenCard), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
                        drawnCards.remove(at: chosenCard)
                    }
                    
                    // Replaces drawn cards if it drops below a certain number
                    if drawnCards.count < startingNumOfCards && cards.count >= 3 {
                        drawCards()
                    }
                } else {
                    score.decreaseScore(by: 2)
                    successfulMatch = false
                }
            } else if chosenCardIndices.count > maxChosenCards {
                chosenCardIndices.removeSubrange(0..<chosenCardIndices.count - 1)
            }
        }
    }
    
    mutating func drawCards() {
        assert(cards.count >= 3, "There aren't at least three cards to draw.")
        assert(drawnCards.count < 24, "There are too many drawn cards.")
        for _ in 0..<3 {
            drawnCards.append(cards.removeFirst())
        }
    }
    
    mutating func startNewGame() {
        // Reset any variables that might have been modified during a game
        score.resetScore()
        matched = false
        successfulMatch = false
        chosenCardIndices.removeAll()
        cards = createSetDeck()
        sortCards(cards: &cards)
        drawnCards.removeAll()
        
        // Draw the initial cards required to start the game
        for _ in 0..<startingNumOfCards {
            drawnCards.append(cards.removeFirst())
        }
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

// Checks if three set cards are a successful match.
private func threeSetCardsMatchSuccessfully(_ c1: SetCard, _ c2: SetCard, _ c3: SetCard) -> Bool {
    if sameOrAllDifferent(c1.color, c2.color, c3.color) &&
        sameOrAllDifferent(c1.symbol, c2.symbol, c3.symbol) &&
        sameOrAllDifferent(c1.shading, c2.shading, c3.shading) &&
        sameOrAllDifferent(c1.number, c2.number, c3.number) {
        return true
    }
    return false
}

// Takes three properties of type T that comform to the Equatable protocol and checks whether or not they are all equal or unique.
private func sameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
    if (a == b && a == c) || (a != b && a != c && b != c) {
        return true
    }
    return false
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
