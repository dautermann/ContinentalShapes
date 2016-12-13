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
    
    
    func parseServerData(data : Data)
    {
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
                    fillCircleStruct(array: Array(array[startIndex+2...currentIndex-2]))
                case 0x02 : // rectangle
                    fillRectangleStruct(array: Array(array[startIndex+2...currentIndex-2]))
                    break
                case 0x03 : // triangle
                    fillTriangleStruct(array: Array(array[startIndex+2...currentIndex-2]))
                    break
                default :
                    print("bogus shape?")
                }
            }
            currentIndex=currentIndex+1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let client = TCPClient(address: "35.165.6.237", port: 4001)

        switch client.connect(timeout: 10) {
        case .success:
        // Connection successful 🎉
            let data = loadServerData(client: client)
            
            parseServerData(data: data)
            
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

