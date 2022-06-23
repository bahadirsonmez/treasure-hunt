//
//  CurrentHuntDetailViewModel.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 23.06.2022.
//

import UIKit

class CurrentHuntDetailViewModel: NSObject {
    
    private let model: HuntModel
    
    init(model: HuntModel) {
        self.model = model
    }
    
    var passedDistance: Double = 0.0 {
        didSet {
            updateCompletion?()
        }
    }
    
    var updateCompletion: (() ->Void)?

    var passedDistanceStringValue: String {
        String(Int(passedDistance)) + " meters"
    }
    
    var estimatedDistance: String? {
        guard let distance = model.estimatedDistance else { return nil }
        return String(Int(distance)) + " meters"
    }
}
