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
                //TODO: Reenable this later
                // Checks if cards match successfully and applies a score bonus or penalty.
//                if threeSetCardsMatchSuccessfully(cardOne: cards[chosenCardIndices[0]], cardTwo: cards[chosenCardIndices[1]], cardThree: cards[chosenCardIndices[2]]) {
                if true {
                    successfulMatch = true
                    score.increaseScore(by: 5)
                    //TODO: Move matched cards out of deck
                    chosenCardIndices.sort(by: >)
                    for chosenCard in chosenCardIndices {
                        //TODO: This needs to remove greatest index to smallest.
                        // Right now it crashes because removing index out of bounds after removing a lower index first
                        print("removed \(chosenCard)")
                        drawnCards.remove(at: chosenCard)
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
    
    //TODO: make sure this works
    mutating func drawCard() {
        for _ in 0..<3 {
            if let card = cards.first {
                drawnCards.append(card)
            }
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
private func threeSetCardsMatchSuccessfully(cardOne: SetCard, cardTwo: SetCard, cardThree: SetCard) -> Bool {
    if sameOrAllDifferent(cardOne.color, cardTwo.color, cardThree.color) &&
        sameOrAllDifferent(cardOne.symbol, cardTwo.symbol, cardThree.symbol) &&
        sameOrAllDifferent(cardOne.shading, cardTwo.shading, cardThree.shading) &&
        sameOrAllDifferent(cardOne.number, cardTwo.number, cardThree.number) {
        return true
    }
    return false
}

// Takes three properties of type T that comform to the Equatable protocol and checks whether or not they are all equal or unique.
private func sameOrAllDifferent<T: Equatable>(_ a: T, _ b: T, _ c: T) -> Bool {
    if a == b && a == c {
        return true
    } else if a != b && a != c && b != c{
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
