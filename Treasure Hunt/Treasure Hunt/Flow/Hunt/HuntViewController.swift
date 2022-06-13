//
//  HuntViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 12.06.2022.
//

import UIKit
import MapKit

class HuntViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var startButton: UIButton!
    private var isStarted: Bool = false {
        didSet {
            configureButton()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        configureButton()
    }
    
    private func configureButton() {
        startButton.backgroundColor = isStarted ? .redButtonColor : .greenButtonColor
        startButton.layer.cornerRadius = 8.0
        startButton.setTitle(isStarted ? "Pause Hunt" : "Start Hunt", for: .normal)
        startButton.setTitleColor(.systemBackground, for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)
    }
    
    @IBAction private func startButtonTapped(_ sender: UIButton) {
        isStarted.toggle()
    }
    
}
