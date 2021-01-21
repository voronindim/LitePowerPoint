//
//  CommonTypes.swift
//  LitePowerPoint
//
//  Created by Dmitrii Voronin on 21.01.2021.
//

import Foundation

struct Size: Equatable {
    let width: Double
    let hegiht: Double
}

struct Point: Equatable {
    let x: Double
    let y: Double
}

struct Rect: Equatable {
    let leftTop: Point
    let size: Size
}
