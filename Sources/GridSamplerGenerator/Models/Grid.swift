//
//  Grid.swift
//  GridSamplerGenerator
//
//  Created by Chiaote Ni on 2022/4/28.
//

import Foundation

struct Grid {
    let gridName: String
    let width: Float
    let height: Float
    let isVip: Bool
    let isFilled: Bool
    let slots: [Slot]
}

struct Slot {
    let boundingBox: CGRect
    let dPath: String?
    let layer: Int?
    let relatedPhotoId: Float?
}
