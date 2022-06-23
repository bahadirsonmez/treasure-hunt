//
//  HuntModel.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 23.06.2022.
//

import Foundation

struct HuntModel: Codable {
    var estimatedDistance: Double?
    var estimatedTime: Int?
    var isFinalPoint: Bool = false
}
