//
//  SettingsViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit
import MediaPlayer

enum TableViewSettingsCellTag: Int {
    case
    timer,
    sound,
    flicker
    
    static var count: Int {    return TableViewSettingsCellTag.flicker.rawValue + 1}
}

protocol SettingsViewControllerDelegate :class {
    func saveClicked(_ controller: SettingsViewController)
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SettingsViewControllerDelegate?
    var currentSetting = Setting()
    var mediaPicker: MPMediaPickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentSetting = MainSetting
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        MainSetting.copyValue(setting: self.currentSetting)
        self.dismiss(animated: true) {
            self.delegate?.saveClicked(self)
        }
    }
}

extension SettingsViewController {
    private func addTimerVC() {
        let timerVC : TimerViewController = self.storyboard!.instantiateViewController(withIdentifier: "timerVC") as! TimerViewController
        self.view.addSubview(timerVC.view)
        self.addChild(timerVC)
        timerVC.view.layoutIfNeeded()
        timerVC.delegate = self
        timerVC.setupTimer(time: self.currentSetting.timer)
    }
    
    private func addChooseColorVC() {
        let chooseColorVC : ChooseColorViewController = self.storyboard!.instantiateViewController(withIdentifier: "chooseColorVC") as! ChooseColorViewController
        self.view.addSubview(chooseColorVC.view)
        self.addChild(chooseColorVC)
        chooseColorVC.view.layoutIfNeeded()
        chooseColorVC.delegate = self
        chooseColorVC.setupChooseColor(color: self.currentSetting.flashColor)
    }
    
    private func removeChildVC(controller: UIViewController) {
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        controller.willMove(toParent: nil)
    }
    
    private func musicOpen() {
        mediaPicker = MPMediaPickerController.self(mediaTypes: MPMediaType.anyAudio)
        mediaPicker?.delegate = self
        mediaPicker?.allowsPickingMultipleItems = false
        
        self.present(mediaPicker!, animated: true, completion: nil)
    }
}

extension SettingsViewController: TimerViewControllerDelegate, ChooseColorViewControllerDelegate {
    func cancelClicked(_ controller: TimerViewController) {
        self.removeChildVC(controller: controller)
    }
    
    func setTimerClicked(_ controller: TimerViewController, time: TimeInterval) {
        self.currentSetting.timer = time
        self.removeChildVC(controller: controller)
        self.tableView.reloadRows(at: [IndexPath(row: TableViewSettingsCellTag.timer.rawValue, section: 0)], with: .none)
    }
    
    func cancelClicked(_ controller: ChooseColorViewController) {
        self.removeChildVC(controller: controller)
    }
    
    func setColorClicked(_ controller: ChooseColorViewController, color: UIColor?) {
        self.removeChildVC(controller: controller)
        self.currentSetting.flashColor = color
        self.tableView.reloadRows(at: [IndexPath(row: TableViewSettingsCellTag.flicker.rawValue, section: 0)], with: .none)
    }
}

extension SettingsViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let item = mediaItemCollection.items.first! as MPMediaItem
        self.currentSetting.musicUrl = (item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL)!
        if self.currentSetting.musicUrl != nil {
            self.currentSetting.noiseType = .none
        }
        mediaPicker.dismiss(animated: true) {
            self.tableView.reloadRows(at: [IndexPath(row: TableViewSettingsCellTag.sound.rawValue, section: 0)], with: .none)
        }
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewSettingsCellTag.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell:TableViewSettingsCellTag = TableViewSettingsCellTag(rawValue: indexPath.row)!
        
        switch currentCell
        {
        case .timer:
            let identifier = "SettingsTimerTableViewCell"
            var cell: SettingsTimerTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTimerTableViewCell
            if cell == nil
            {
                tableView.register(UINib(nibName: "SettingsTimerTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsTimerTableViewCell
            }
            
            cell.setupCell(setting: self.currentSetting)
            cell.blockSwitchTimerChangedHandler = { isTimer in
                self.currentSetting.isTimer = isTimer
            }

            cell.blockButtonTimerOpenHandler = {
                self.addTimerVC()
            }
            
            return cell
        case .sound:
            let identifier = "SettingsSoundTableViewCell"
            var cell: SettingsSoundTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsSoundTableViewCell
            if cell == nil
            {
                tableView.register(UINib(nibName: "SettingsSoundTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsSoundTableViewCell
            }

            cell.setupCell(setting: self.currentSetting)
            cell.blockNoiseTypeSelectedHandler = { noiseType in
                if noiseType == self.currentSetting.noiseType {
                    self.currentSetting.noiseType = .none
                } else {
                    self.currentSetting.noiseType = noiseType
                    self.currentSetting.musicUrl = nil
                }                
                
                self.tableView.reloadRows(at: [IndexPath(row: TableViewSettingsCellTag.sound.rawValue, section: 0)], with: .none)
            }
            
            cell.blockButtonMusicOpenHandler = {
                self.musicOpen()
            }
            
            return cell
        case .flicker:
            let identifier = "SettingsFlickerTableViewCell"
            var cell: SettingsFlickerTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsFlickerTableViewCell
            if cell == nil
            {
                tableView.register(UINib(nibName: "SettingsFlickerTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingsFlickerTableViewCell
            }
            
            cell.setupCell(setting: self.currentSetting)
            cell.blockSliderBrightnessValueChangedHandler = { value in
                self.currentSetting.brightnessValue = value
            }
            
            cell.blockSwitchFlashingChangedHandler = { isFlashing in
                self.currentSetting.isFlashing = isFlashing
            }
            
            cell.blockButtonChooseColorOpenHandler = {
                self.addChooseColorVC()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
