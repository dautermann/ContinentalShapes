//
//  ViewController.swift
//  ContinentalShapes
//
//  Created by Michael Dautermann on 12/10/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

import UIKit
import SwiftSocket

class ViewController: UIViewController {
    
    @IBOutlet var shapeView : ShapeView!
    @IBOutlet var scrollView : UIScrollView!
    
    func loadServerData(client : TCPClient) -> Data
    {
        var serverData = Data()
        
        repeat {
            guard let data = client.read(11516) else { print("well that was fun") ; break }
            
            serverData.append(data, count: data.count)
        } while (1 == 1)
        
        print("server data length is \(serverData.count)")
        
        return serverData
    }
    
    
    func parseServerData(data : Data) -> [AnyObject]
    {
        var shapeObjects = [AnyObject]()
        var currentIndex = 0
        var startIndex = 0;
        let array = [UInt8](data)
        for eachWord in array {
            if eachWord == 0x55 {
                startIndex = currentIndex
            }
            if eachWord == 0xa5 {
                // let's look at the next byte to see what kind of shape this might be?
                let potentialShapeByte = array[startIndex+1]
                NSLog("2) next word or shapetype is 0x%X", potentialShapeByte)
                
                switch potentialShapeByte {
                case 0x01 : // circle
                    if let circleStruct = ShapeData.fillCircleStruct(array: Array(array[startIndex+2...currentIndex-2]))
                    {
                        shapeObjects.append(circleStruct as AnyObject)
                    }
                case 0x02 : // rectangle
                    if let rectangleStruct = ShapeData.fillRectangleStruct(array: Array(array[startIndex+2...currentIndex-2])) {
                        shapeObjects.append(rectangleStruct as AnyObject)
                    }
                    break
                case 0x03 : // triangle
                    if let triangleStruct = ShapeData.fillTriangleStruct(array: Array(array[startIndex+2...currentIndex-2])) {
                        shapeObjects.append(triangleStruct as AnyObject)
                    }
                    break
                default :
                    print("bogus shape?")
                }
            }
            currentIndex=currentIndex+1
        }
        return shapeObjects
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let client = TCPClient(address: "35.165.6.237", port: 4001)

        switch client.connect(timeout: 10) {
        case .success:
        // Connection successful 🎉
            let data = loadServerData(client: client)
            
            if data.isEmpty == false {
                let shapeObjects = parseServerData(data: data)
                
                if shapeObjects.count > 0 {
                    shapeView.updateShapeObjects(newShapeObjects: shapeObjects)
                }
                
                print("content view height and width is \(scrollView.contentSize.height) & w: \(scrollView.contentSize.width) & shapeView height \(shapeView.frame.size.height) & width \(shapeView.frame.size.width)")
            }
            
        case .failure(let error):
            // 💩
            print("💩")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

