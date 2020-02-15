//
//  MainViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 13/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var planetsBackgroundView: UIView!
    @IBOutlet weak var mountainsBackgroundView: UIView!
    @IBOutlet weak var presetsView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var frequencyTypeNormalLabel: UILabel!
    @IBOutlet weak var soundTypeNormalLabel: UILabel!
    @IBOutlet weak var soundButtonView: UIView!
    @IBOutlet weak var lightButtonView: UIView!
    @IBOutlet weak var playButtonView: UIView!
    
    @IBOutlet weak var tip1View: UIView!
    @IBOutlet weak var tip2View: UIView!
    
    var currentFrequencyType: FrequencyType = .delta
    var currentFrequency: Float!
    var isSoundOn: Bool = true
    var isLightOn: Bool = true
    var isPlaying: Bool = false
    var selectedTimerDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.setupControlView()
        self.applyFrequency()
        
        self.tip1View.isHidden = false
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.touchedView (_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func touchedView(_ sender:UITapGestureRecognizer){
        if !self.tip1View.isHidden {
            self.tip1View.isHidden = true
            self.tip2View.isHidden = false
        } else if !self.tip2View.isHidden {
            self.tip2View.isHidden = true
        }
    }
    
    @IBAction func timerClicked(_ sender: Any) {
        self.addTimerVC()
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        
    }
    
    @IBAction func changePresetClicked(_ sender: Any) {
        if !self.tip1View.isHidden {
            self.tip1View.isHidden = true
            self.tip2View.isHidden = false
        }
        
        self.addPresetsVC()
    }
    
    @IBAction func soundOnOffClicked(_ sender: UIButton) {
        self.isSoundOn = !self.isSoundOn
        self.setupSoundButtonView()
    }
    
    @IBAction func lightOnOffClicked(_ sender: UIButton) {
        self.isLightOn = !self.isLightOn
        self.setupLightButtonView()
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton) {
        self.isPlaying = !self.isPlaying
        self.setupPlayButtonView()
    }
}

extension MainViewController {
    private func initView() {

    }
    
    private func setupControlView() {
        self.setupSoundButtonView()
        self.setupLightButtonView()
        self.setupPlayButtonView()
    }
    
    private func setupSoundButtonView() {
        for subView in self.soundButtonView.subviews {
            if subView is UIImageView {
                let imageView = subView as! UIImageView
                imageView.image = UIImage(named: self.isSoundOn ? "button_sound_on" : "button_sound_off")
            }
            if subView is UILabel {
                let label = subView as! UILabel
                label.text = self.isSoundOn ? "SOUND ON" : "SOUND OFF"
                label.textColor = self.isSoundOn ? UIColor.white : UIColor(hexString: mainBlackColor)
            }
        }
    }
    
    private func setupLightButtonView() {
        for subView in self.lightButtonView.subviews {
            if subView is UIImageView {
                let imageView = subView as! UIImageView
                imageView.image = UIImage(named: self.isLightOn ? "button_light_on" : "button_light_off")
            }
            if subView is UILabel {
                let label = subView as! UILabel
                label.text = self.isLightOn ? "LIGHT ON" : "LIGHT OFF"
                label.textColor = self.isLightOn ? UIColor.white : UIColor(hexString: mainBlackColor)
            }
        }
    }
    
    private func setupPlayButtonView() {
        for subView in self.playButtonView.subviews {
            if subView is UIImageView {
                let imageView = subView as! UIImageView
                imageView.image = UIImage(named: self.isPlaying ? "button_pause" : "button_play")
            }
            if subView is UILabel {
                let label = subView as! UILabel
                label.text = self.isPlaying ? "PAUSE" : "PLAY"
                label.textColor = self.isPlaying ? UIColor(hexString: mainBlackColor) : UIColor.white
            }
        }
    }
    
    private func applyFrequency() {
        self.frequencyTypeNormalLabel.text = self.currentFrequencyType.title

        switch self.currentFrequencyType {
        case .delta, .theta, .alpha:
            self.showPlanetsBackground(true)
        case .beta:
            self.planetsBackgroundView.isHidden = false
            self.mountainsBackgroundView.isHidden = false
            let alphaValue = (self.currentFrequency - FrequencyType.alpha.maxFrequency) / (FrequencyType.beta.maxFrequency - FrequencyType.alpha.maxFrequency)
            
            self.planetsBackgroundView.alpha = CGFloat(1 - alphaValue)
            self.mountainsBackgroundView.alpha = CGFloat(alphaValue)
        default:
            self.showPlanetsBackground(false)
        }
    }
    
    private func showPlanetsBackground(_ isPlanets: Bool) {
        self.planetsBackgroundView.isHidden = !isPlanets
        self.mountainsBackgroundView.isHidden = isPlanets
        
        self.planetsBackgroundView.alpha = 1.0
        self.mountainsBackgroundView.alpha = 1.0
    }
    
    private func addTimerVC() {
        let timerVC : TimerViewController = self.storyboard!.instantiateViewController(withIdentifier: "timerVC") as! TimerViewController
        self.view.addSubview(timerVC.view)
        self.addChild(timerVC)
        timerVC.view.layoutIfNeeded()
        timerVC.delegate = self
        timerVC.setupTimer(date: self.selectedTimerDate)
    }
    
    private func addPresetsVC() {
        let presetsVC : PresetsViewController = self.storyboard!.instantiateViewController(withIdentifier: "presetsVC") as! PresetsViewController
        self.view.addSubview(presetsVC.view)
        self.addChild(presetsVC)
        presetsVC.view.layoutIfNeeded()
        presetsVC.delegate = self
        presetsVC.setupPresets()
    }
    
    private func removeChildVC(controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        controller.willMove(toParent: nil)
    }
}

extension MainViewController: TimerViewControllerDelegate, PresetsViewControllerDelegate {
    func cancelClicked(_ controller: TimerViewController) {
        self.removeChildVC(controller: controller)
    }
    
    func setTimerClicked(_ controller: TimerViewController, date: Date) {
        self.selectedTimerDate = date
        self.removeChildVC(controller: controller)
    }
    
    func cancelClicked(_ controller: PresetsViewController) {
        self.removeChildVC(controller: controller)
    }
    
    func presetSelected(_ controller: PresetsViewController, date: Date) {
        
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.tip2View.isHidden {
            self.tip2View.isHidden = true
        }
        
        let offset_y = scrollView.contentOffset.y
        
        if offset_y < 0 {
            self.currentFrequencyType = .delta
        } else {
            self.currentFrequency = Float(offset_y / (scrollView.contentSize.height - UIScreen.main.bounds.height)) *  FREQUENCY_MAX
            
            if self.currentFrequency < FrequencyType.delta.maxFrequency {
                self.currentFrequencyType = .delta
            } else if self.currentFrequency < FrequencyType.theta.maxFrequency {
                self.currentFrequencyType = .theta
            } else if self.currentFrequency < FrequencyType.alpha.maxFrequency {
                self.currentFrequencyType = .alpha
            } else if self.currentFrequency < FrequencyType.beta.maxFrequency {
                self.currentFrequencyType = .beta
            } else {
                self.currentFrequencyType = .gamma
            }
            
//            self.frequencyLabel.text = String(self.currentFrequency.roundTo(places: 2)) + " Hz"
        }
        
        self.applyFrequency()
    }
}
