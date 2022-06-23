//
//  CurrentHuntDetailViewModel.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 23.06.2022.
//

import UIKit

class CurrentHuntDetailViewModel: NSObject {
    
    private var model: HuntModel {
        didSet {
            updateCompletion?()
        }
    }

    init(model: HuntModel) {
        self.model = model
    }
    
    private var timer: Timer?
    
    func updateModel(_ model: HuntModel) {
        self.model = model
    }
    
    var updateCompletion: (() ->Void)?
    
    var passedDistance: Double = 0.0 {
        didSet {
            updateCompletion?()
        }
    }

    var passedDistanceStringValue: String {
        String(Int(passedDistance)) + " meters"
    }
    
    var estimatedDistance: String? {
        guard let distance = model.estimatedDistance else { return nil }
        return String(Int(distance)) + " meters"
    }
    
    
}
