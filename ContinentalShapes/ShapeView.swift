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
    
    override func awakeFromNib() {
        
        let zoomFactor : CGFloat = 10.0
        let heightAndWidth : CGFloat = (32767.0 / zoomFactor )
        
        self.frame = CGRect(x: 0.0, y: 0.0, width: heightAndWidth, height: heightAndWidth)
    }
    

}
