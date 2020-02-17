//
//  TimerViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

protocol TimerViewControllerDelegate: class {
    func cancelClicked(_ controller: TimerViewController)
    func setTimerClicked(_ controller: TimerViewController, time: TimeInterval)
}

class TimerViewController: UIViewController {

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    weak var delegate: TimerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupTimer(time: TimeInterval?) {
        if let time = time {
            self.timePickerView.countDownDuration = time
        }
        
        self.timerView.frame.origin.y = self.view.frame.size.height
        
        UIView.animate(withDuration: 0.5, animations: {
            self.timerView.frame.origin.y = self.view.frame.size.height - self.timerView.frame.size.height - 21
        }) { (finished) in
        }
    }
    
    private func hideTimer(cancel: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.timerView.frame.origin.y = self.view.frame.size.height
        }) { (finished) in
            if cancel {
                self.delegate?.cancelClicked(self)
            } else {
                self.delegate?.setTimerClicked(self, time: self.timePickerView.countDownDuration)
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.hideTimer(cancel: true)
    }
    
    @IBAction func setTimerClicked(_ sender: Any) {
        self.hideTimer(cancel: false)
    }
}
