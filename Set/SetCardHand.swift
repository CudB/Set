//
//  SetCardHand.swift
//  Set
//
//  Created by Andy Au on 2019-01-09.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation

class SetCardHand: SetCardDeck
{
    func discardCardsAtIndices(_ indices: [Int]) {
        var sortedIndices = indices
        sortedIndices.sort(by: >)
        for index in sortedIndices {
            assert(cards.indices.contains(index), "SetCardHand.removeCardsAtIndices(): Index \(index) was not found in cards.")
            cards.remove(at: index)
        }
    }
    
    override init() {
        super.init()
        cards.removeAll()
    }
}
