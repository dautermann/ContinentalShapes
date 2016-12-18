//
//  ShapeView.swift
//  ContinentalShapes
//
//  Created by Michael Dautermann on 12/13/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

import Foundation
import UIKit

class ShapeView : UIView {
    
    var shapeObjects = [AnyObject]()
    let zoomFactor : CGFloat = 10.0

    override func awakeFromNib() {
        
        let heightAndWidth : CGFloat = (32767.0 / zoomFactor )
        
        self.frame = CGRect(x: 0.0, y: 0.0, width: heightAndWidth, height: heightAndWidth)
        
        if let parentView = self.superview
        {
            if let parentScrollView = parentView as? UIScrollView
            {
                print("content size is \(parentScrollView.contentSize.height) & width \(parentScrollView.contentSize.width)")
                parentScrollView.contentSize.height = heightAndWidth
                parentScrollView.contentSize.width = heightAndWidth
                print("content size is \(parentScrollView.contentSize.height) & width \(parentScrollView.contentSize.width)")

            }
        }
        
        thisIsAnnoyingSoVeryMuchGRR()
    }
    
    func thisIsAnnoyingSoVeryMuchGRR() {
        let newLayer = CAShapeLayer()
        //let newRectangle = RectangleStruct(x: 100, y: 800, width: 1000, height: 1000, rgba: 0)
        let newRectangle = RectangleStruct(x: 5376, y: 9984, width: 9472, height: 302, rgba: 0)
        drawRectangle(newRectangle, into: newLayer)
    }

    func drawCircle(_ circleStruct: CircleStruct, into layer: CAShapeLayer) {
        let x = CGFloat(circleStruct.x) / zoomFactor
        let y = CGFloat(circleStruct.y) / zoomFactor
        let r = CGFloat(circleStruct.radius) / zoomFactor
        let color:UIColor = UIColor.black
        
        let arcCenter = CGPoint(x: x, y: y)
        let dcircle = UIBezierPath.init(arcCenter: arcCenter, radius: r, startAngle: 0.0, endAngle: 360.0, clockwise: false)
        print("drawCircle x \(x) y\(y) radius \(r) ")

        layer.fillRule = kCAFillRuleNonZero
        layer.lineCap = kCALineCapButt
        layer.lineWidth = 1.0
        layer.strokeColor = color.cgColor
        layer.fillColor = color.cgColor
        layer.path = dcircle.cgPath
        self.layer.addSublayer(layer)
    }
    
    func drawRectangle(_ rectangleStruct: RectangleStruct, into layer: CAShapeLayer) {
        let h = CGFloat(rectangleStruct.height) / zoomFactor
        let w = CGFloat(rectangleStruct.width) / zoomFactor
        let x = CGFloat(rectangleStruct.x) / zoomFactor
        let y = CGFloat(rectangleStruct.y) / zoomFactor
        let color:UIColor = UIColor.black
        
        let drect = CGRect(x: x, y: y, width: w, height: h)
//print("drawRectangle x \(drect.origin.x) y\(drect.origin.y) h \(drect.size.height) w \(drect.size.width)")
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        
        layer.fillRule = kCAFillRuleNonZero
        layer.lineCap = kCALineCapButt
        layer.lineWidth = 1.0
        layer.strokeColor = color.cgColor
        layer.fillColor = color.cgColor
        layer.path = bpath.cgPath
        self.layer.addSublayer(layer)
    }
    
    func drawTriangle(_ triangleStruct: TriangleStruct, into layer: CAShapeLayer) {
        let path = UIBezierPath()
        let x1 = CGFloat(triangleStruct.x1) / zoomFactor
        let y1 = CGFloat(triangleStruct.y1) / zoomFactor
        let x2 = CGFloat(triangleStruct.x2) / zoomFactor
        let y2 = CGFloat(triangleStruct.y2) / zoomFactor
        let x3 = CGFloat(triangleStruct.x3) / zoomFactor
        let y3 = CGFloat(triangleStruct.y3) / zoomFactor
        let color:UIColor = UIColor.black

        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        path.addLine(to: CGPoint(x: x3, y: y3)) // #3
        path.close()
        layer.fillRule = kCAFillRuleNonZero
        layer.lineCap = kCALineCapButt
        layer.lineWidth = 1.0
        layer.strokeColor = color.cgColor
        layer.fillColor = color.cgColor
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
    }
    
    func display() {
        let layer = self.layer
        layer.setNeedsDisplay()
        layer.displayIfNeeded()
    }
    
    func updateShapeObjects(newShapeObjects : [AnyObject])
    {
        shapeObjects = newShapeObjects

        var index = 0
        
        for eachObject in shapeObjects {
//            break
            
            let myLayer = CAShapeLayer()
//            myLayer.delegate = self

            if let eachCircle = eachObject as? CircleStruct {
                drawCircle(eachCircle, into: myLayer)
            }
            
            if let eachRect = eachObject as? RectangleStruct
            {
                drawRectangle(eachRect, into: myLayer)
                index = index+1
            }
            
            if let eachTriangle = eachObject as? TriangleStruct {
                drawTriangle(eachTriangle, into: myLayer)
            }
            
            self.layer.addSublayer(myLayer)
            
//            if index > 15 {
//                break
//            }
        }
        
        display()
    }
}
