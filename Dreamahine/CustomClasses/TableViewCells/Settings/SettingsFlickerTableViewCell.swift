//
//  SettingsFlickerTableViewCell.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class SettingsFlickerTableViewCell: UITableViewCell {

    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var flashingSwitch: UISwitch!
    @IBOutlet weak var colorView: UIView!
    
    var blockSliderBrightnessValueChangedHandler:((Float)->Void)?
    var blockSwitchFlashingChangedHandler:((Bool)->Void)?
    var blockButtonChooseColorOpenHandler:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(setting: Setting) {
        self.brightnessSlider.value = setting.brightnessValue
        self.flashingSwitch.isOn = setting.isFlashing
        self.colorView.backgroundColor = setting.flashColor
    }
    
    @IBAction func brightnessValueChanged(_ sender: Any) {
        if(self.blockSliderBrightnessValueChangedHandler != nil){
            self.blockSliderBrightnessValueChangedHandler!(self.brightnessSlider.value)
        }
    }
    
    @IBAction func flashingSwitchValueChanged(_ sender: Any) {
        if(self.blockSwitchFlashingChangedHandler != nil){
            self.blockSwitchFlashingChangedHandler!(self.flashingSwitch.isOn)
        }
    }
    
    @IBAction func chooseColorOpenClicked(_ sender: Any) {
        if(self.blockButtonChooseColorOpenHandler != nil){
            self.blockButtonChooseColorOpenHandler!()
        }
    }
}
