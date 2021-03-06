//
//  CurrentHuntDetailViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 14.06.2022.
//

import UIKit

protocol CurrentHuntDetailDelegate: AnyObject {
    func firstClueCompleted()
    func huntCompleted()
    func huntFailed()
}

class CurrentHuntDetailViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var walkLabel: UILabel!
    
    private var timer: Timer?
    private var passedTime: Int = 0
    
    private let viewModel: CurrentHuntDetailViewModel
    
    weak var delegate: CurrentHuntDetailDelegate?
    
    // MARK: - Initializers
    
    init(viewModel: CurrentHuntDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        bindViewModel()
        configureData()
    }
    
    private func bindViewModel() {
        viewModel.updateCompletion = { [weak self] in
            self?.walkLabel.text = self?.viewModel.passedDistanceStringValue
        }
    }
    
    private func configureData() {
        goalLabel.text = viewModel.estimatedDistance
        walkLabel.text = viewModel.passedDistanceStringValue
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
        LocationManager.shared.clearLocationsArray()
        timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func runTimedCode() {
        passedTime += 1
        timerLabel.text = FormatHelper.formatMinuteSeconds(passedTime)
        if let distance = LocationManager.shared.calculateDistanceBetweenLastTwoLocations() {
            viewModel.passedDistance += distance
        }
    }
    
}

// MARK: - FloatingPanelLayout

final class CurrentHuntDetailLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition { .half }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .half: return 300
        case .tip: return 120
        default: return nil
        }
    }
    
    var supportedPositions: Set<FloatingPanelPosition> { [.half, .tip] }
    
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        0.1
    }
}

