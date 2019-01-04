//
//  Set.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

struct Set {
    let maxDrawnCards = 24
    private let maxChosenCards = 3
    private let startingNumOfCards = 12
    private(set) var chosenCardIndices = [Int]()
    private(set) var score = Score()
    private(set) var matched = false
    private(set) var successfulMatch = false
    private(set) var deck = SetCardDeck()
    private(set) var drawnCards = [SetCard]()

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
                    
                    // Sort the indices so the cards are removed from the deck in descending order. This ensures the indices of the cards that need to be removed don't change during the for loop.
                    chosenCardIndices.sort(by: >)
                    for chosenCardIndex in chosenCardIndices {
                        assert(drawnCards.indices.contains(chosenCardIndex), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
                        drawnCards.remove(at: chosenCardIndex)
                    }
                    
                    // Replaces matched cards.
                    if deck.cards.count >= 3 {
                        draw(amount: 3)
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
    
    mutating func draw(amount: Int) {
        drawnCards.append(contentsOf: deck.draw(amount: amount))
    }
    
    mutating func startNewGame() {
        // Reset any variables that might have been modified during a game
        score.resetScore()
        matched = false
        successfulMatch = false
        chosenCardIndices.removeAll()
        
        // Set up a deck and draw cards\
        deck = SetCardDeck()
        deck.shuffle()
        drawnCards.removeAll()
        draw(amount: startingNumOfCards)
    }
    
    init() {
        startNewGame()
    }
}
