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
    
    @IBOutlet weak var titleFrequencyLabel: UILabel!
    @IBOutlet weak var titlePresetLabel: UILabel!
    
    var currentFrequencyType: FrequencyType = .delta
    var beatFrequency: Float = FREQUENCY_MIN {
        didSet {
            BeatManager.shared.changeBinauralFrequency(frequency: beatFrequency)
        }
    }
    
    var isPlaying: Bool = false
    var currentPreset: Preset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsVC" {
            let settingsVC = segue.destination as! SettingsViewController
            settingsVC.delegate = self
        }
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
    
    @IBAction func changePresetClicked(_ sender: Any) {
        if !self.tip1View.isHidden {
            self.tip1View.isHidden = true
            self.tip2View.isHidden = false
        }
        
        self.addPresetsVC()
    }
    
    @IBAction func soundOnOffClicked(_ sender: UIButton) {
        MainSetting.isSound = !MainSetting.isSound
        self.setupSoundButtonView()
        
        if self.isPlaying {
            self.playBeatAndSound()
        }
    }
    
    @IBAction func lightOnOffClicked(_ sender: UIButton) {
        MainSetting.isLight = !MainSetting.isLight
        self.setupLightButtonView()
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton) {
        self.isPlaying = !self.isPlaying
        self.setupPlayButtonView()
        
        self.playAllSettings()
    }
}

extension MainViewController {
    private func initView() {
        self.setupControlView()
        self.applyFrequency()
        
        self.tip1View.isHidden = false
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.touchedView (_:)))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func setupTitleLabel() {
        self.titleFrequencyLabel.text = "\(self.currentFrequencyType.description):"
        self.titlePresetLabel.text = self.currentPreset != nil ? self.currentPreset!.title : "No Preset"
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
                imageView.image = UIImage(named: MainSetting.isSound ? "button_sound_on" : "button_sound_off")
            }
            if subView is UILabel {
                let label = subView as! UILabel
                label.text = MainSetting.isSound ? "SOUND ON" : "SOUND OFF"
                label.textColor = MainSetting.isSound ? UIColor.white : UIColor(hexString: MAIN_BLACK_COLOR)
            }
        }
    }
    
    private func setupLightButtonView() {
        for subView in self.lightButtonView.subviews {
            if subView is UIImageView {
                let imageView = subView as! UIImageView
                imageView.image = UIImage(named: MainSetting.isLight ? "button_light_on" : "button_light_off")
            }
            if subView is UILabel {
                let label = subView as! UILabel
                label.text = MainSetting.isLight ? "LIGHT ON" : "LIGHT OFF"
                label.textColor = MainSetting.isLight ? UIColor.white : UIColor(hexString: MAIN_BLACK_COLOR)
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
                label.textColor = self.isPlaying ? UIColor(hexString: MAIN_BLACK_COLOR) : UIColor.white
            }
        }
    }
    
    private func showStaticUI() {
        self.navigationView.isHidden = false
        self.controlView.isHidden = false
        self.mainView.isHidden = false
    }
    
    private func hideStaticUI () {
        self.navigationView.isHidden = true
        self.controlView.isHidden = true
        self.mainView.isHidden = true
    }
    
    private func applyFrequency() {
        self.frequencyTypeNormalLabel.text = self.currentFrequencyType.title

        switch self.currentFrequencyType {
        case .delta, .theta, .alpha:
            self.showPlanetsBackground(true)
        case .beta:
            self.planetsBackgroundView.isHidden = false
            self.mountainsBackgroundView.isHidden = false
            let alphaValue = (self.beatFrequency - FrequencyType.alpha.maxFrequency) / (FrequencyType.beta.maxFrequency - FrequencyType.alpha.maxFrequency)
            
            self.planetsBackgroundView.alpha = CGFloat(1 - alphaValue)
            self.mountainsBackgroundView.alpha = CGFloat(alphaValue)
        default:
            self.showPlanetsBackground(false)
        }
        
        self.setupTitleLabel()
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
        timerVC.setupTimer(time: MainSetting.timer)
    }
    
    private func addPresetsVC() {
        let presetsVC : PresetsViewController = self.storyboard!.instantiateViewController(withIdentifier: "presetsVC") as! PresetsViewController
        self.view.addSubview(presetsVC.view)
        self.addChild(presetsVC)
        presetsVC.view.layoutIfNeeded()
        presetsVC.delegate = self
        presetsVC.setupPresets()
    }
    
    private func addFlickingVC() {
        let flickingVC : FlickingViewController = self.storyboard!.instantiateViewController(withIdentifier: "flickingVC") as! FlickingViewController
        self.view.addSubview(flickingVC.view)
        self.addChild(flickingVC)
        flickingVC.view.layoutIfNeeded()
        flickingVC.delegate = self
        flickingVC.beatFrequency = self.beatFrequency
        self.hideStaticUI()
    }
    
    private func removeChildVC(controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        controller.willMove(toParent: nil)
    }
    
    private func playAllSettings() {
        if MainSetting.isLight {
            if MainSetting.flashColor != nil {
                self.addFlickingVC()
                return
            }
        }
        
        self.playBeatAndSound()
    }
    
    private func playBeatAndSound() {
        if MainSetting.isSound {
            if self.isPlaying {
                BeatManager.shared.playBeat(play: self.isPlaying)
                if MainSetting.noiseType != .none {
                    SoundManager.shared.playSoundWithName(MainSetting.noiseType.fileName, MainSetting.noiseType.fileType)
                }
                
                if let musicUrl = MainSetting.musicUrl {
                    SoundManager.shared.playSoundWithPath(musicUrl)
                }
            }
        }
        
        if !MainSetting.isSound || !self.isPlaying {
            BeatManager.shared.playBeat(play: false)
            SoundManager.shared.stopSound()
        }
    }
}

extension MainViewController: FlickingViewControllerDelegate, SettingsViewControllerDelegate, TimerViewControllerDelegate, PresetsViewControllerDelegate {
    func startFlicking(_ controller: FlickingViewController) {
        self.playBeatAndSound()
    }
    
    func finishFlicking(_ controller: FlickingViewController) {
        self.removeChildVC(controller: controller)
        self.showStaticUI()
        self.isPlaying = false
        self.setupPlayButtonView()
        self.playBeatAndSound()
    }
    
    func saveClicked(_ controller: SettingsViewController) {
        if self.isPlaying {
            self.playAllSettings()
        }
    }
    
    func cancelClicked(_ controller: TimerViewController) {
        self.removeChildVC(controller: controller)
    }
    
    func setTimerClicked(_ controller: TimerViewController, time: TimeInterval) {
        MainSetting.timer = time
        self.removeChildVC(controller: controller)
    }
    
    func cancelClicked(_ controller: PresetsViewController) {
        self.removeChildVC(controller: controller)
    }
    
    func presetSelected(_ controller: PresetsViewController, preset: Preset) {
        self.removeChildVC(controller: controller)
        MainSetting.copyValue(setting: preset.setting)
        self.currentPreset = preset
        self.setupTitleLabel()
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
            self.beatFrequency = Float(offset_y / (scrollView.contentSize.height - UIScreen.main.bounds.height)) *  FREQUENCY_MAX
            
            if self.beatFrequency < FrequencyType.delta.maxFrequency {
                self.currentFrequencyType = .delta
            } else if self.beatFrequency < FrequencyType.theta.maxFrequency {
                self.currentFrequencyType = .theta
            } else if self.beatFrequency < FrequencyType.alpha.maxFrequency {
                self.currentFrequencyType = .alpha
            } else if self.beatFrequency < FrequencyType.beta.maxFrequency {
                self.currentFrequencyType = .beta
            } else {
                self.currentFrequencyType = .gamma
            }
            
//            self.frequencyLabel.text = String(self.currentFrequency.roundTo(places: 2)) + " Hz"
        }
        
        self.applyFrequency()
    }
}
