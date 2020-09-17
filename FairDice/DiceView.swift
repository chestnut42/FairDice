//
//  DiceView.swift
//  FairDice
//
//  Created by Andrey on 17/09/2020.
//  Copyright © 2020 am18. All rights reserved.
//

import Foundation
import UIKit


extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: CGPoint(x: originX, y: originY), size: size)
    }
    
    init(center: CGPoint, squareSize: CGFloat) {
        self.init(center: center, size: CGSize(width: squareSize, height: squareSize))
    }
}


class DiceView : UIView {
    
    static let layoutInset = CGFloat(0.15)
    static let dotRectSize = CGFloat(0.85)
    static let dotSize = CGFloat(0.7)
    
    
    var dice1: UInt32 = 42 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var dice2: UInt32 = 42 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dice1 = arc4random_uniform(6)
        dice2 = arc4random_uniform(6)
    }
    
    override func draw(_ rect: CGRect) {
        let wholeRect = self.bounds
        let insetValue = min(wholeRect.width, wholeRect.height) * DiceView.layoutInset
        let workingRect = wholeRect.insetBy(dx: insetValue, dy: insetValue)
        
        let lowerRect = CGRect(
            origin: workingRect.origin,
            size: CGSize(
                width: workingRect.width,
                height: (workingRect.height - insetValue) * 0.5
            )
        )
        let higherRect = CGRect(
            origin: CGPoint(
                x: workingRect.origin.x,
                y: workingRect.origin.y + lowerRect.size.height + insetValue
            ),
            size: lowerRect.size
        )
        
        drawDice(in: lowerRect, number: dice1)
        drawDice(in: higherRect, number: dice2)
    }
    
    func drawDice(in rect: CGRect, number: UInt32) {
        let workingSize = min(rect.width, rect.height)
        let workingCenter = CGPoint(x: rect.midX, y: rect.midY)
        let workingSquare = CGRect(center: workingCenter, squareSize: workingSize)
        
        UIColor.black.setStroke()
        UIColor.init(red: 0.957, green: 0.263, blue: 0.212, alpha: 1.0).setFill()
        UIBezierPath(roundedRect: workingSquare, cornerRadius: workingSize * 0.1).stroke()
        
        let dotMainRect = CGRect(center: workingCenter, squareSize: workingSize * DiceView.dotRectSize)
        let dots = getDots(for: number) ?? []
        let dotRects = dots.compactMap() {d in getDotRect(number: d, in: dotMainRect)}
        
        if dots.count == dotRects.count {
            for dr in dotRects {
                let path = UIBezierPath(ovalIn: dr)
                path.fill()
                path.stroke()
            }
        }
    }
    
    func getDots(for number: UInt32) -> [Int]? {
        switch number {
        case 0:
            return [4]
        case 1:
            return [2, 6]
        case 2:
            return [2, 4, 6]
        case 3:
            return [0, 2, 6, 8]
        case 4:
            return [0, 2, 4, 6, 8]
        case 5:
            return [0, 1, 2, 6, 7, 8]
        default:
            return nil
        }
    }
    
    func getDotRect(number: Int, in rect: CGRect) -> CGRect? {
        if number < 0 {
            return nil
        }
        if number >= 9 {
            return nil
        }
        
        let row = number / 3
        let column = number % 3
        let center = CGPoint(
            x: rect.origin.x + rect.width / 6.0 + CGFloat(column) * (rect.width / 3.0),
            y: rect.origin.y + rect.height / 6.0 + CGFloat(row) * (rect.height / 3.0)
        )
        let size = (min(rect.width, rect.height) / 3.0) * DiceView.dotSize
        return CGRect(center: center, size: CGSize(width: size, height: size))
    }
    
}

