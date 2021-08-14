//
//  ViewController.swift
//  AppEventCount
//
//  Created by wickedRun on 2021/08/09.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var didFinishLaunchingLabel: UILabel!
    var didFinishLaunchingCount = 0
    @IBOutlet var configurationForConnectingLabel: UILabel!
    var configurationForConnectingCount = 0
    @IBOutlet var willConnectLabel: UILabel!
    var willConnectCount = 0
    @IBOutlet var didBecomeActiveLabel: UILabel!
    var didBecomeActiveCount = 0
    @IBOutlet var willResignActiveLabel: UILabel!
    var willResignActiveCount = 0
    @IBOutlet var willEnterForegroundLabel: UILabel!
    var willEnterForegroundCount = 0
    @IBOutlet var didEnterBackgroundLabel: UILabel!
    var didEnterBackgroundCount = 0
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    func updateView() {
        didFinishLaunchingLabel.text = "The App has launched \(appDelegate.launchCount) time(s)"
        configurationForConnectingLabel.text = "configurationForConnecting \(appDelegate.configurationForConnectingCount) time(s)"
        willConnectLabel.text = "The scene will be connected \(willConnectCount) time(s)"
        didBecomeActiveLabel.text = "The scene become Active state \(didBecomeActiveCount) tiem(s)"
        willResignActiveLabel.text = "The scene is resigned Active state \(willResignActiveCount) time(s)"
        willEnterForegroundLabel.text = "The scene will enter Foreground state \(willEnterForegroundCount) time(s)"
        didEnterBackgroundLabel.text = "The scene has entered Background state \(didEnterBackgroundCount) time(s)"
    }
    
}

