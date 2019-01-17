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
    
    private(set) var deck = SetCardDeck()
    private(set) var hand = SetCardHand()
    private(set) var chosenCardIndices = [Int]()
    private(set) var statistics = SetGameStatistics()
    private(set) var successfulMatchMade = false
    private(set) var matchMade = false

    mutating func chooseCard(at index: Int) {
        assert(hand.cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
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
                
                // Check for successful match.
                if [hand.cards[chosenCardIndices[0]], hand.cards[chosenCardIndices[1]], hand.cards[chosenCardIndices[2]]].successfulMatch {
                    successfulMatchMade = true
                    hand.discardCardsAtIndices(chosenCardIndices)
                    chosenCardIndices.removeAll()
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
            } else if chosenCardIndices.count > CardLimits.maxChosenCards {
                // Remove currently selected cards if the maximum allowed has already been selected before selecting a new one.
                chosenCardIndices.removeSubrange(0..<chosenCardIndices.count - 1)
            }
        }
    }
    
    //TODO: Do something about this function? Using it to let the view controller draw cards.
    mutating func draw(amount: Int) {
        hand.cards.append(contentsOf: deck.draw(amount: amount))
    }
    
    mutating func startNewGame() {
        // Reset any variables that might have been modified during a game.
        matchMade = false
        successfulMatchMade = false
        chosenCardIndices.removeAll()
        statistics.reset()
        
        // Set up a deck and draw cards.
        deck.createNewDeck()
        hand.cards.removeAll()
        draw(amount: CardLimits.startingNumOfCards)
    }
    
    init() {
        startNewGame()
    }
}
