//
//  CurrentHuntDetailViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 14.06.2022.
//

import UIKit
import FloatingPanel

protocol CurrentHuntDetailDelegate: AnyObject {
    func huntCompleted()
    func huntFailed()
}

extension CurrentHuntDetailDelegate {
    func huntCompleted() {}
    func huntFailed() {}
}

class CurrentHuntDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension CurrentHuntDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        CurrentHuntDetailLayout()
    }
}

final class CurrentHuntDetailLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition { .half }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .half: return 300
        case .tip: return 60
        default: return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> { [.half, .tip] }
    
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        0.1
    }
}

