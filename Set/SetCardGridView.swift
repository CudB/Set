//
//  SetCardGridView.swift
//  Set
//
//  Created by Andy Au on 2019-01-16.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

//@IBDesignable
class SetCardGridView: UIView {
    var cardSubViews = [UIView]()
    
    var numberOfCards = 12
    
    // Create a grid that will be used to lay out cards represented by SetCardView.
    lazy var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardDimensionRatio), frame: bounds)
    
    private func createSetCard() -> UIView {
        let card = SetCardView(type: SetCard.Symbol.squiggle, color: SetCard.Color.blue, number: SetCard.Number.three, shading: SetCard.Shading.striped, frame: frame)
        addSubview(card)
        return card
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subView in cardSubViews {
            subView.removeFromSuperview()
        }
        
        grid.cellCount = numberOfCards
        grid.frame = bounds

        for cellIndex in 0..<grid.cellCount {
            if let cell = grid[cellIndex] {
                let card = createSetCard()
                card.frame.size = scaleCGSize(by: Constants.cardSizeToGridCellSizeRatio, size: cell.size)
                card.frame.origin = cell.origin.offsetBy(dx: (cell.size.width - card.frame.size.width)/2, dy: (cell.size.height - card.frame.size.height)/2)
                card.backgroundColor = UIColor.clear
                cardSubViews.append(card)
            }
        }
        
    }

    private struct Constants {
        static let cardDimensionRatio: CGFloat = 5/8
        static let cardSizeToGridCellSizeRatio: CGFloat = 0.9
    }
    private func scaleCGSize(by scaleFactor: CGFloat, size: CGSize) -> CGSize {
        return CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
    }
    
}
