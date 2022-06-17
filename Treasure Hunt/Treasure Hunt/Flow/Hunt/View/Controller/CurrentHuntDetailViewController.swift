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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var walkLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    private var isPaused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
       configureButton()
    }
    
    private func configureButton() {
        continueButton.contentHorizontalAlignment = .fill
        continueButton.contentVerticalAlignment = .fill
        continueButton.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        isPaused.toggle()
        let image = UIImage(systemName: isPaused ? "play.fill" : "pause.fill")
        continueButton.setImage(image, for: .normal)
    }
}

extension CurrentHuntDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        CurrentHuntDetailLayout()
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        // Removal
    }
}

final class CurrentHuntDetailLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition { .half }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .half: return 300
        case .tip: return 100
        default: return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> { [.half, .tip] }
    
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        0.1
    }
}

