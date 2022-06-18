//
//  CurrentHuntDetailViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 14.06.2022.
//

import UIKit

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
    private var timer: Timer?
    private var passedTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillMoveToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
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
        isPaused ? pauseTimer() : continueTimer()
        let image = UIImage(systemName: isPaused ? "play.fill" : "pause.fill")
        continueButton.setImage(image, for: .normal)
    }
}

// MARK: - Timer

extension CurrentHuntDetailViewController {
    @objc func applicationWillEnterForeground() {
        if passedTime != 0 {
            let lastTimestamp = UserDefaults.standard.double(forKey: "currentTimestamp")
            let lastTimeInterval = TimeInterval(lastTimestamp)
            let now = TimeInterval(NSDate().timeIntervalSince1970)
            let passedTime = UserDefaults.standard.integer(forKey: "passedTime")
            self.passedTime = passedTime + Int(now - lastTimeInterval)
        }
    }
    
    @objc func applicationWillMoveToBackground() {
        UserDefaults.standard.set(self.passedTime, forKey: "passedTime")
    }
    
    func startTimer() {
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    func continueTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func runTimedCode() {
        passedTime += 1
        timerLabel.text = FormatHelper.formatMinuteSeconds(passedTime)
    }

}

// MARK: - FloatingPanelControllerDelegate

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

