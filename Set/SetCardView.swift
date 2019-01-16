//
//  SetCardView.swift
//  Set
//
//  Created by Andy Au on 2019-01-10.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    var type = SetCard.Symbol.oval
    var color = SetCard.Color.blue
    var number = SetCard.Number.two
    var shading = SetCard.Shading.open
    
    override func draw(_ rect: CGRect) {
        // Create the card boundaries.
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        // Create the face of the card and fit it to the frame.
        let cardFaceFrame = CGRect(origin: cardFaceFrameOrigin, size: cardFaceFrameSize)
        drawCardFace(type: type, number: number, color: color, shading: shading, inFrame: cardFaceFrame)
    }
    
    private func drawCardFace(type: SetCard.Symbol, number: SetCard.Number, color: SetCard.Color, shading: SetCard.Shading, inFrame frame: CGRect) {
        
        var drawFunc: (CGRect) -> UIBezierPath
        let symbolSize = calculateSymbolSize(within: frame)
        
        switch color {
        case .red:
            UIColor.red.setFill()
            UIColor.red.setStroke()
        case .green:
            UIColor.green.setFill()
            UIColor.green.setStroke()
        case .blue:
            UIColor.blue.setFill()
            UIColor.blue.setStroke()
        }
        
        switch type {
        case .oval:
            drawFunc = drawOval
        case .diamond:
            drawFunc = drawDiamond
        case .squiggle:
            drawFunc = drawSquiggle
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            switch number {
            case .one:
                let symbolFrame = CGRect(origin: frame.origin.offsetBy(dx: 0, dy: frame.height/3), size: symbolSize)
                drawSymbol(with: drawFunc, shading: shading, frame: symbolFrame)
            case .two:
                var symbolFrame = CGRect(origin: frame.origin.offsetBy(dx: 0, dy: frame.height/6), size: symbolSize)
                context.saveGState()
                drawSymbol(with: drawFunc, shading: shading, frame: symbolFrame)
                context.restoreGState()
                symbolFrame.origin = frame.origin.offsetBy(dx: 0, dy: frame.height/2)
                drawSymbol(with: drawFunc, shading: shading, frame: symbolFrame)
            case .three:
                var symbolFrame = CGRect(origin: frame.origin, size: symbolSize)
                for dy in stride(from: 0, to: frame.height, by: frame.height/3) {
                    symbolFrame.origin = frame.origin.offsetBy(dx: 0, dy: dy)
                    context.saveGState()
                    drawSymbol(with: drawFunc, shading: shading, frame: symbolFrame)
                    context.restoreGState()
                }
            }
        }
    }
    
    private func drawSymbol(with drawFunc: (CGRect) -> UIBezierPath, shading: SetCard.Shading, frame: CGRect) {
        let path = drawFunc(frame)
        switch shading {
        case .open:
            path.stroke()
        case .solid:
            path.fill()
        case .striped:
            path.stroke()
            path.addClip()
            drawStripes(in: frame, for: path).stroke()
        }
    }
    
    private func drawOval(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: rect)
    }
    
    private func drawDiamond(in rect: CGRect) -> UIBezierPath {
        let diamond = UIBezierPath()
        diamond.move(to: rect.origin.offsetBy(dx: rect.width/2, dy: 0))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: rect.width/2, dy: rect.height/2))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: -rect.width/2, dy: rect.height/2))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: -rect.width/2, dy: -rect.height/2))
        diamond.addLine(to: diamond.currentPoint.offsetBy(dx: rect.width/2, dy: -rect.height/2))
        return diamond
    }
    
    private func drawSquiggle(in rect: CGRect) -> UIBezierPath {
        // Drawing this curve was the most asinine thing I have ever done. I'm sure there's a clever way to figure out the numbers for these curves and I've just wasted my time.
        let squiggle = UIBezierPath()
        squiggle.move(to: rect.origin.offsetBy(dx: rect.width * 0.15, dy: rect.height * 0.87))
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width, dy: rect.height * 0.5),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 0.5, dy: rect.height * 0.4),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.75, dy: rect.height * 1.3)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width * 0.85, dy: rect.height * 0.1),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 1.1, dy: rect.height * 0.07),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.9, dy: rect.height * -0.03)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: 0, dy: rect.height * 0.5),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * 0.5, dy: rect.height * 0.6),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.2, dy: rect.height * -0.4)
        )
        squiggle.addCurve(
            to: rect.origin.offsetBy(dx: rect.width * 0.15, dy: rect.height * 0.87),
            controlPoint1: rect.origin.offsetBy(dx: rect.width * -0.1, dy: rect.height * 0.9),
            controlPoint2: rect.origin.offsetBy(dx: rect.width * 0.1, dy: rect.height * 0.95)
        )
        return squiggle
    }
    
    private func drawStripes(in rect: CGRect, for symbol: UIBezierPath) -> UIBezierPath {
        let stripes = UIBezierPath()
        stripes.move(to: rect.origin)
        for x in stride(from: floor(rect.origin.x - 10), to: floor(rect.origin.x + rect.width + 10), by: 1) {
            if x.truncatingRemainder(dividingBy: 4) == 0 {
                stripes.move(to: CGPoint(x: CGFloat(x), y: rect.origin.y))
                stripes.addLine(to: CGPoint(x: CGFloat(x), y: rect.origin.y + rect.height))
            }
        }
        symbol.addClip()
        return stripes
    }
    
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cardFaceFrameWidthToBoundsWidth: CGFloat = 0.55
        static let cardFaceFrameHeightToBoundsHeight: CGFloat = 0.70
        static let symbolSizeToGridCellSize: CGFloat = 0.8
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cardFaceFrameOrigin: CGPoint {
        return CGPoint(x: (bounds.size.width - bounds.size.width * SizeRatio.cardFaceFrameWidthToBoundsWidth)/2.0, y: (bounds.size.height - bounds.size.height * SizeRatio.cardFaceFrameHeightToBoundsHeight)/2.0)
    }
    private var cardFaceFrameSize: CGSize {
        return CGSize(width: bounds.width * SizeRatio.cardFaceFrameWidthToBoundsWidth, height: bounds.height * SizeRatio.cardFaceFrameHeightToBoundsHeight)
    }
    private func calculateSymbolSize(within frame: CGRect) -> CGSize {
        return CGSize(width: frame.width, height: frame.height/3.75)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

extension CGRect {
    func center() -> CGPoint {
        return origin.offsetBy(dx:width/2, dy:height/2)
    }
}
