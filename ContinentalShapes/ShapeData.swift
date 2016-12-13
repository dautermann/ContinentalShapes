//
//  ShapeData.swift
//  ContinentalShapes
//
//  Created by Michael Dautermann on 12/10/16.
//  Copyright © 2016 Michael Dautermann. All rights reserved.
//

import Foundation

enum ShapeType {
    case Circle
    case Rectangle
    case Triangle
}

struct ShapeData {
    func fillCircleStruct(array : [UInt8]) -> CircleStruct? {
        
        if Validate.checkIfEnoughBytesToFillCircle(array: array) {
            do {
                let x = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[0]))
                let y = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[2]))
                let radius = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[4]))
                let rgba = try Validate.validateUInt32(input: UInt32(array[6]))
                let cStruct : CircleStruct = CircleStruct(x: x, y: y, radius: radius, rgba: rgba)
                print("x is \(cStruct.x) & y is \(cStruct.y) radius is \(cStruct.radius) & rgba is \(cStruct.rgba)")
                return cStruct
            } catch {
                // no need to throw errors to the user or console if parsing failed for this demo app...
                // ignoring bogus data is just a feature
            }
        }
        return nil
    }
    
    func fillRectangleStruct(array : [UInt8]) -> RectangleStruct? {
        if Validate.checkIfEnoughBytesToFillRectangle(array: array) {
            do {
                let x = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[0]))
                let y = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[2]))
                let width = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[4]))
                let height = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[6]))
                let rgba = try Validate.validateUInt32(input: UInt32(array[8]))
                let cStruct : RectangleStruct = RectangleStruct(x: x, y: y, width: width, height : height, rgba: rgba)
                print("x is \(cStruct.x) & y is \(cStruct.y) width is \(cStruct.width) height is \(cStruct.height) & rgba is \(cStruct.rgba)")
                return cStruct
            } catch {
            }
        }
        return nil
    }
    
    func fillTriangleStruct(array : [UInt8]) -> TriangleStruct? {
        if Validate.checkIfEnoughBytesToFillTriangle(array: array) {
            do {
                let x1 = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[0]))
                let y1 = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[2]))
                let x2 = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[4]))
                let y2 = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[6]))
                let x3 = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[8]))
                let y3 = try Validate.swapBigToHostAndValidateUInt16(input: UInt16(array[10]))
                let rgba = try Validate.validateUInt32(input: UInt32(array[8]))
                let cStruct : TriangleStruct = TriangleStruct(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3, rgba: rgba)
                print("x1: \(cStruct.x1) y1: \(cStruct.y1) ; x2: \(cStruct.x2) y2: \(cStruct.y2) ; x3: \(cStruct.x3) y3: \(cStruct.y3) & rgba is \(cStruct.rgba)")
                return cStruct
            } catch {
                
            }
        }
        return nil
    }
}

struct CircleStruct {
    var x : UInt16
    var y : UInt16
    var radius : UInt16
    var rgba : UInt32
}

struct RectangleStruct {
    var x : UInt16
    var y : UInt16
    var width : UInt16
    var height : UInt16
    var rgba : UInt32
}

struct TriangleStruct {
    var x1 : UInt16
    var y1 : UInt16
    var x2 : UInt16
    var y2 : UInt16
    var x3 : UInt16
    var y3 : UInt16
    var rgba : UInt32
}

struct Validate {
    enum ValidateError: Error {
        case overMaximumError
    }

    static func checkIfEnoughBytesToFillCircle(array : [UInt8]) -> Bool
    {
        if array.count == 10 {
            return true
        }
        return false
    }
    
    static func checkIfEnoughBytesToFillRectangle(array : [UInt8]) -> Bool
    {
        if array.count == 12 {
            return true
        }
        return false
    }
    
    static func checkIfEnoughBytesToFillTriangle(array : [UInt8]) -> Bool
    {
        if array.count == 16 {
            return true
        }
        return false
    }
    
    static func swapBigToHostAndValidateUInt16(input : UInt16) throws -> UInt16
    {
        if input > 0xff
        {
            throw ValidateError.overMaximumError
        }
        
        return UInt16(bigEndian: input)
    }

    static func validateUInt32(input : UInt32) throws -> UInt32
    {
        if input > 0xffff
        {
            throw ValidateError.overMaximumError
        }
        
        return input
    }
}
