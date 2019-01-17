//
//  SetCardGridView.swift
//  Set
//
//  Created by Andy Au on 2019-01-16.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

//@IBDesignable
class SetCardGridView: UIView
{
    var cardSubViews = [UIView]()
    
    var cards = [SetCard]() { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    // Create a grid that will be used to lay out cards represented by SetCardView.
    lazy var grid = Grid(layout: Grid.Layout.aspectRatio(Constants.cardDimensionRatio), frame: bounds)
    
    private func createSetCard(index: Int) -> UIView {
        let card = SetCardView(card: cards[index], frame: frame)
        addSubview(card)
        return card
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subView in cardSubViews {
            subView.removeFromSuperview()
        }
        
        grid.cellCount = cards.count
        grid.frame = bounds

        for index in 0..<grid.cellCount {
            if let cell = grid[index] {
                let card = createSetCard(index: index)
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
