//
//  DrawingView.swift
//  PolyDraw
//
//  Created by Chris Chadillon on 2017-03-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class DrawingView: UIView {
    
    var shapeType = 0
    var theShapes = [Shape]()
    var initialPoint: CGPoint!
    var isThereAPartialShape : Bool = false
    var thePartialShape : Shape!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let possibleContext = UIGraphicsGetCurrentContext()
        
        if let theContext = possibleContext {
            theContext.setLineWidth(1.0)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let components:[CGFloat] = [0.0, 0.0, 1.0, 1.0]
            let color = CGColor(colorSpace: colorSpace, components: components)
            theContext.setStrokeColor(color!)
            
            for aShape in self.theShapes {
                aShape.draw(theContext)
            }
            
            if self.isThereAPartialShape {
                self.thePartialShape.draw(theContext)
            }
            
            theContext.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        self.initialPoint = touch.location(in: self)
        self.isThereAPartialShape = true
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let newPoint = touch.location(in: self)
        
        let topLeftPoint = CGPoint(x: self.initialPoint.x < newPoint.x ? self.initialPoint.x : newPoint.x,
                                   y: self.initialPoint.y < newPoint.y ? self.initialPoint.y : newPoint.y)
        
        if self.isThereAPartialShape {
            if shapeType == 0 {
                self.thePartialShape = Rect(X: Double(topLeftPoint.x),
                                            Y: Double(topLeftPoint.y),
                                            theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                            theWidth: abs(Double(self.initialPoint.x-newPoint.x)))
            } else {
                self.thePartialShape = Oval(X: Double(topLeftPoint.x),
                                            Y: Double(topLeftPoint.y),
                                            theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                            theWidth: abs(Double(self.initialPoint.x-newPoint.x)))
            }
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theShape = self.thePartialShape {
            self.theShapes.append(theShape)
        }
        self.isThereAPartialShape = false
    }
}





