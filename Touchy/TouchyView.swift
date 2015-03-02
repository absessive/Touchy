//
//  TouchyView.swift
//  Touchy
//
//  Created by Ajit Chakrapani on 3/1/15.
//  Copyright (c) 2015 absessive. All rights reserved.
//

import UIKit

class TouchyView: UIView {
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent) {
        updateTouches(event.allTouches())
    }
    
    var touchPoints = [CGPoint]()
    
    func updateTouches( touches: NSSet? ) {
        touchPoints = []
        touches?.enumerateObjectsUsingBlock() { (element,stop) in
            if let touch = element as? UITouch {
                switch touch.phase {
                case .Began, .Moved, .Stationary:
                    self.touchPoints.append(touch.locationInView(self))
                default:
                    break
                }
            }
        }
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIColor.blackColor().set()
        CGContextFillRect(context,rect)
        
        var connectionPath: UIBezierPath?
        if touchPoints.count>1 {
            for location in touchPoints {
                if let path = connectionPath {
                    path.addLineToPoint(location)
                }
                else {
                    connectionPath = UIBezierPath()
                    connectionPath!.moveToPoint(location)
                }
            }
            if touchPoints.count>2 {
                connectionPath!.closePath()
            }
        }
        
        if let path = connectionPath {
            UIColor.lightGrayColor().set()
            path.lineWidth = 6
            path.lineCapStyle = kCGLineCapRound
            path.lineJoinStyle = kCGLineJoinRound
            path.stroke()
        }
        
        var colors = [UIColor.yellowColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.whiteColor(), UIColor.cyanColor(), UIColor.magentaColor(), UIColor.orangeColor(), UIColor.purpleColor()]
        
        var touchNumber = 0

        for location in touchPoints {
            var index = Int(arc4random_uniform(UInt32(colors.count)))
            let fontAttributes = [
                NSFontAttributeName:            UIFont.boldSystemFontOfSize(180),
                NSForegroundColorAttributeName: colors[index]
            ];
            let text: NSString = "\(++touchNumber)"
            let size = text.sizeWithAttributes(fontAttributes)
            let textCorner = CGPoint(x: location.x-size.width/2,
                y: location.y-size.height/2)
            text.drawAtPoint(textCorner, withAttributes: fontAttributes)
        }
        
    }
}
