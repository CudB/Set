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
    var description: String {
        return ""
    }
    
    private(set) var score = 0
    private(set) var scoreAdded = 0
    private(set) var scoreDeducted = 0
    private(set) var matchesMade = 0
    private(set) var successfulMatches = 0
    private(set) var unsuccessfulMatches = 0
    
    mutating func reset() {
        score = 0
        scoreAdded = 0
        scoreDeducted = 0
        matchesMade = 0
        successfulMatches = 0
        unsuccessfulMatches = 0
    }
    
    mutating func incrementScore(by amount: Int) {
        scoreAdded += amount
        score += amount
    }
    
    mutating func decrementScore(by amount: Int) {
        scoreDeducted += amount
        score -= amount
    }
    
    mutating func addSuccessfulMatch() {
        matchesMade += 1
        successfulMatches += 1
    }
    
    mutating func addUnsuccessfulMatch() {
        matchesMade += 1
        unsuccessfulMatches += 1
    }
}
