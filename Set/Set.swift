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
    private(set) var score = Score()
    private(set) var matched = false
    private(set) var successfulMatch = false

    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
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
            if chosenCardIndices.count == maxChosenCards {
                matched = true
                // Checks if cards match successfully
                if threeSetCardsMatchSuccessfully(cardOne: cards[chosenCardIndices[0]], cardTwo: cards[chosenCardIndices[1]], cardThree: cards[chosenCardIndices[2]]) {
                    successfulMatch = true
                    score.increaseScore(by: 5)
                } else {
                    score.decreaseScore(by: 2)
                    successfulMatch = false
                }
            } else if chosenCardIndices.count > maxChosenCards {
                chosenCardIndices.removeSubrange(0..<chosenCardIndices.count - 1)
            }
        }
    }
    
    // Checks if three set cards are a successful match
    private func threeSetCardsMatchSuccessfully(cardOne: SetCard, cardTwo: SetCard, cardThree: SetCard) -> Bool {
        if sameOrAllDifferent(cardOne.color, cardTwo.color, cardThree.color) &&
                sameOrAllDifferent(cardOne.symbol, cardTwo.symbol, cardThree.symbol) &&
                sameOrAllDifferent(cardOne.shading, cardTwo.shading, cardThree.shading) &&
                sameOrAllDifferent(cardOne.number, cardTwo.number, cardThree.number) {
            return true
        }
        return false
    }
    
    // Checks three equatable properties of the same type to see if they are all equal or unique.
    private func sameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
        if a == b && a == c {
            return true
        } else if a != b && a != c && b != c{
            return true
        }
        return false
    }
    
    mutating func startNewGame() {
        score.resetScore()
        matched = false
        successfulMatch = false
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
