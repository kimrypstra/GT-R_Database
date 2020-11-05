//
//  DataStructures.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 1/11/20.
//

import Foundation

struct R34 {
    let ID: String?
    let VIN: String?
    let Grade: String?
    let Series: String?
    let Colour: String?
    let Production: String?
    let Date: String?
    let Plant: String?
    let Seat: String?
    let Model: String?
}

struct modelNumberStartColumn {
    static let r34: Int32 = 8
}

struct modelNumberOffset {
    static let bodyType: Int32 = 0
    static let engine: Int32 = 2
    static let drive: Int32 = 4
    static let driverSide: Int32 = 6
    static let grade: Int32 = 8
    static let gearbox: Int32 = 10
    static let generation: Int32 = 12
    static let aspiration: Int32 = 14
    static let coldWeather: Int32 = 16
    static let seatCapacity: Int32 = 18
    static let superFineHardCoat: Int32 = 20
    static let glass: Int32 = 22
    static let trim: Int32 = 24
    static let stereo: Int32 = 26
    static let safety: Int32 = 28
}
