//
//  SettingsTimerTableViewCell.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class SettingsTimerTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timerSwitch: UISwitch!

    var blockSwitchTimerChangedHandler:((Bool)->Void)?
    var blockButtonTimerOpenHandler:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(setting: Setting) {
        if let timer = setting.timer {
            self.timeLabel.text = timer.time
        } else {
            self.timeLabel.text = "00:00"
        }
        self.timerSwitch.isOn = setting.isTimer
    }
    
    @IBAction func timerSwitchValueChanged(_ sender: Any) {
        if(self.blockSwitchTimerChangedHandler != nil){
            self.blockSwitchTimerChangedHandler!(self.timerSwitch.isOn)
        }
    }
    
    @IBAction func openTimerClicked(_ sender: Any) {
        if(self.blockButtonTimerOpenHandler != nil){
            self.blockButtonTimerOpenHandler!()
        }
    }
}

extension TimeInterval {
    var time:String {
        let hours = (Int(self) / 3600)
        let minutes = Int(self / 60) - Int(hours * 60)
        
        return String(format: "%0.2d:%0.2d",hours,minutes)
    }
}
