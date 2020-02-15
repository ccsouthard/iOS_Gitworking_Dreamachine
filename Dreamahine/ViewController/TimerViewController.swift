//
//  TimerViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

protocol TimerViewControllerDelegate:class {
    func cancelClicked(_ controller: TimerViewController)
    func setTimerClicked(_ controller: TimerViewController, date: Date)
}

class TimerViewController: UIViewController {

    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    weak var delegate: TimerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupTimer(date: Date?) {
        if let date = date {
            self.timePickerView.date = date
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
                self.delegate?.setTimerClicked(self, date: self.timePickerView.date)
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
