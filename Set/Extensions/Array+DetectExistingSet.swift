//
//  Array+DetectExistingSet.swift
//  Set
//
//  Created by Andy Au on 2018-12-18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import Foundation

extension Array where Element == SetCard {
    // Detects a set within an array of type SetCard.
    var detectedSet: Bool {
        for index1 in 0..<(self.count - 2) {
            for index2 in (index1 + 1)..<(self.count - 1) {
                for index3 in (index2 + 1)..<self.count {
                    if [self[index1], self[index2], self[index3]].successfulMatch {
                        return true
                    }
                }
            }
        }
        return false
    }
}

extension Array where Element == SetCard {
    // Retrieve the indices of a matching set if it exists.
    var retrieveSetIndices: [Int]? {
        for index1 in 0..<(self.count - 2) {
            for index2 in (index1 + 1)..<(self.count - 1) {
                for index3 in (index2 + 1)..<self.count {
                    if [self[index1], self[index2], self[index3]].successfulMatch {
                        return [index1, index2, index3]
                    }
                }
            }
        }
        return nil
    }
}
