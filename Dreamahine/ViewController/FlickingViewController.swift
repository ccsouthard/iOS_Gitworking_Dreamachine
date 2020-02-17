//
//  FlickingViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 16/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit
import AVFoundation

protocol FlickingViewControllerDelegate: class {
    func startFlicking(_ controller: FlickingViewController)
    func finishFlicking(_ controller: FlickingViewController)
}

class FlickingViewController: UIViewController {
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var flickingView: UIView!
    @IBOutlet weak var brightnessView: UIView!
    @IBOutlet weak var flashView: UIView!
    
    weak var delegate: FlickingViewControllerDelegate?
    var countTimer: Timer!
    var beatFrequency: Float!
    var flashTimer : Timer!
    var T = 0.5 ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var countNum = 10
        self.countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if countNum > 0 {
                countNum -= 1
                self.countDownLabel.text = "\(countNum)"
            } else {
                timer.invalidate()
                self.startFlash()
            }
        })
        
        self.brightnessView.alpha = CGFloat(1.0 - Float(MainSetting.brightnessValue))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapedOnView(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    private func startFlash() {
        var countNum = -2
        if MainSetting.isTimer, let timer = MainSetting.timer {
            countNum = Int(timer)
        }
        
        self.delegate?.startFlicking(self)
        self.flickingView.isHidden = false
        self.flashView.backgroundColor = MainSetting.flashColor
        self.flashTimer = Timer.scheduledTimer(withTimeInterval: (T/Double(self.beatFrequency)), repeats: true, block: { (timer) in
            if countNum == -2 {
                self.doFlash()
            } else if countNum > 0 {
                countNum -= 1
                self.doFlash()
            } else {
                timer.invalidate()
                self.delegate?.finishFlicking(self)
            }
        })
    }

    private func doFlash() {
        if MainSetting.isFlashing {
            let device = AVCaptureDevice.default(for: .video)
            if (device?.hasTorch)! {
                do {
                    try device?.lockForConfiguration()
                    if (device?.torchMode == .on) {
                        device?.torchMode = .off
                    } else {
                        do {
                            try device?.setTorchModeOn(level: 1.0)
                        } catch {
                            print(error)
                        }
                    }
                    device?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        } else {
            self.flashView.isHidden = !self.flashView.isHidden;
        }
    }
    
    @objc func tapedOnView(_ sender: UITapGestureRecognizer) {

        if MainSetting.isFlashing {
            if self.flashTimer != nil {
                self.flashTimer.invalidate()
                self.flashTimer = nil;
            }
            
            let device = AVCaptureDevice.default(for: .video)
            if (device?.hasTorch)! {
                do {
                    try device?.lockForConfiguration()
                    if (device?.torchMode == .on) {
                        device?.torchMode = .off
                    }
                    device?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
            
            self.delegate?.finishFlicking(self)
        }
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        self.countTimer.invalidate()
        self.startFlash()
    }
    
    @IBAction func closeFlickeringClicked(_ sender: Any) {
        if self.flashTimer != nil {
            self.flashTimer.invalidate()
            self.flashTimer = nil;
        }
        self.delegate?.finishFlicking(self)
    }
}
