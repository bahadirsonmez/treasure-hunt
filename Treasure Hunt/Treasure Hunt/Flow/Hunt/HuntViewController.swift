//
//  HuntViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 12.06.2022.
//

import UIKit
import MapKit

class HuntViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        configureButton()
    }
    
    private func configureButton() {
        startButton.backgroundColor =
        backButton.backgroundColor = AppManager.color
        backButton.icornerRadius = 5.0
        backButton.setTitleColorForAllStates(AppManager.buttonTitleColor)
        backButton.setTitle(viewModel.buttonTitle, for: .normal)
        backButton.titleLabel?.font(Fonts.interBoldFont(size: 14.0))
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
    }
    
    
}
