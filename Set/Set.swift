//
//  Set.swift
//  Set
//
//  Created by Andy Au on 2018-12-12.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

struct Set
{
    private struct ScoreChange {
        static let onSuccessfulMatch = 5
        static let onUnsuccessfulMatch = -10
        static let onDrawingCardWhileMatchPresent = -10
    }
    
    private struct CardLimits {
        static let maxChosenCards = 3
        static let cardsTakenPerDraw = 3
        static let startingNumOfCards = 12
    }
    
    //TODO: to be removed once scalable card views are implemented.
    let maxDrawnCards = 24
    
    private(set) var deck = SetCardDeck()
    private(set) var drawnCards = [SetCard]()
    private(set) var chosenCardIndices = [Int]()
    private(set) var statistics = SetGameStatistics()
    private(set) var successfulMatchMade = false
    private(set) var matchMade = false {
        didSet {
            if matchMade == true {
                if [drawnCards[chosenCardIndices[0]], drawnCards[chosenCardIndices[1]], drawnCards[chosenCardIndices[2]]].successfulMatch {
                    successfulMatchMade = true
                    removeIndicesFromCards(indices: &chosenCardIndices, cards: &drawnCards)
                    statistics.adjustScore(by: ScoreChange.onSuccessfulMatch)
                    statistics.successfulMatchMade(is: true)
                    
                    // Replaces matched cards.
                    if deck.cards.count >= CardLimits.cardsTakenPerDraw {
                        draw(amount: CardLimits.cardsTakenPerDraw)
                    }
                } else {
                    successfulMatchMade = false
                    statistics.adjustScore(by: ScoreChange.onUnsuccessfulMatch)
                    statistics.successfulMatchMade(is: false)
                }
            }
        }
    }

    mutating func chooseCard(at index: Int) {
        assert(drawnCards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        outerLoop: if chosenCardIndices.isEmpty {
            chosenCardIndices.append(index)
            matchMade = false
        } else {
            for chosenIndex in chosenCardIndices.indices {
                // Unselect the chosen card if it has already been selected and break the loop early.
                if chosenCardIndices[chosenIndex] == index && chosenCardIndices.count != CardLimits.maxChosenCards{
                    chosenCardIndices.remove(at: chosenIndex)
                    break outerLoop
                }
            }
            chosenCardIndices.append(index)
            
            // Checks if a match occurs.
            if chosenCardIndices.count == CardLimits.maxChosenCards {
                matchMade = true
            } else if chosenCardIndices.count > CardLimits.maxChosenCards {
                // Remove currently selected cards if the maximum allowed has already been selected before selecting a new one.
                chosenCardIndices.removeSubrange(0..<chosenCardIndices.count - 1)
            }
        }
    }
    
    mutating func draw(amount: Int) {
        drawnCards.append(contentsOf: deck.draw(amount: amount))
    }
    
    mutating func startNewGame() {
        // Reset any variables that might have been modified during a game.
        matchMade = false
        successfulMatchMade = false
        chosenCardIndices.removeAll()
        statistics.reset()
        
        // Set up a deck and draw cards.
        deck.createNewDeck()
        drawnCards.removeAll()
        draw(amount: CardLimits.startingNumOfCards)
    }
    
    private func removeIndicesFromCards(indices: inout [Int], cards: inout [SetCard]) {
        // Sort the indices so the cards are removed from the deck in descending order. This ensures the indices of the cards that need to be removed don't change during the for loop.
        indices.sort(by: >)
        for index in indices {
            assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
            cards.remove(at: index)
        }
        indices.removeAll()
    }
    
    init() {
        startNewGame()
    }
}
