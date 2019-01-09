//
//  SetGameStatistics.swift
//  Set
//
//  Created by Andy Au on 2019-01-05.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation

struct SetGameStatistics: CustomStringConvertible
{
    private(set) var score = 0
    private(set) var scoreAdded = 0
    private(set) var scoreDeducted = 0
    private(set) var matchesMade = 0
    private(set) var successfulMatches = 0
    private(set) var unsuccessfulMatches = 0
    
    var description: String {
        var description = ""
        description.append("Game statistics for the current game of Set:")
        description.append("\nTotal Score: " + String(score))
        description.append("\nScore Added: " + String(scoreAdded))
        description.append("\nScore Deducted: " + String(scoreDeducted))
        description.append("\nTotal Matches Made: " + String(matchesMade))
        description.append("\nSuccessful Matches Made: " + String(successfulMatches))
        description.append("\nUnsuccessful Matches Made: " + String(unsuccessfulMatches))
        return description
    }
    
    mutating func reset() {
        score = 0
        scoreAdded = 0
        scoreDeducted = 0
        matchesMade = 0
        successfulMatches = 0
        unsuccessfulMatches = 0
    }
    
    mutating func adjustScore(by amount: Int) {
        if amount > 0 {
            scoreAdded += amount
        } else {
            scoreDeducted += amount
        }
        score += amount
    }
    
    mutating func successfulMatchMade(is successful: Bool) {
        if successful {
            successfulMatches += 1
        } else {
            unsuccessfulMatches += 1
        }
        matchesMade += 1
    }
}
