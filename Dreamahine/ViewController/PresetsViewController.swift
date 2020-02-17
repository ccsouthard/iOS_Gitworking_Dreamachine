//
//  PresetsViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 14/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

protocol PresetsViewControllerDelegate:class {
    func cancelClicked(_ controller: PresetsViewController)
    func presetSelected(_ controller: PresetsViewController, preset: Preset)
}

class PresetsViewController: UIViewController {
    @IBOutlet weak var presetsView: UIView!
    @IBOutlet weak var presetsTableView: UITableView!
    
    weak var delegate: PresetsViewControllerDelegate?
    
    var presets: [Preset] = []
    var popularPresets: [Preset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPresets()
    }
    
    func setupPresets() {
        self.presetsView.frame.origin.y = self.view.frame.size.height
        
        UIView.animate(withDuration: 0.5, animations: {
            self.presetsView.frame.origin.y = (self.view.frame.size.height - self.presetsView.frame.size.height) / 2
        }) { (finished) in
        }
    }
    
    private func hidePresets(cancel: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.presetsView.frame.origin.y = self.view.frame.size.height
        }) { (finished) in
            if cancel {
                self.delegate?.cancelClicked(self)
            } else {

            }
        }
    }
    
    private func loadPresets() {
        if let url = Bundle.main.url(forResource: "presets", withExtension: "plist"),
            let presetData = try? Data(contentsOf: url),
            let presetsPlist = try? PropertyListSerialization.propertyList(from: presetData, options: [], format: nil) as? [NSDictionary] {
            for presetDict in presetsPlist {
                self.presets.append(Preset(dict: presetDict))
            }
            
            self.presetsTableView.reloadData()
        }
        
        if let usedPresets = UserDefaults.standard.array(forKey: STRING_USED_PRESETS) as? [String], !usedPresets.isEmpty {
            // Create dictionary to map value to count
            var counts = [String: Int]()

            // Count the values with using forEach
            usedPresets.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }

            // Find the most frequent value and its count with max(by:)
            if let (value, count) = counts.max(by: {$0.1 < $1.1}) {
                print("\(value) occurs \(count) times")
                if let mostPopularPreset = self.presets.first(where: {$0.title == value}) {
                    self.popularPresets.append(mostPopularPreset)
                }
                if let lastUsedPreset = self.presets.first(where: {$0.title == usedPresets.last}) {
                    self.popularPresets.append(lastUsedPreset)
                }
                
                self.presetsTableView.reloadData()
            }            
        }
    }
    
    private func storePreset(_ preset: Preset) {
        var usedPresets: [String] = UserDefaults.standard.stringArray(forKey: STRING_USED_PRESETS) ?? []
        usedPresets.append(preset.title)
        UserDefaults.standard.set(usedPresets, forKey: STRING_USED_PRESETS)
    }
    
    private func getPreset(from title: String) {
        
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.hidePresets(cancel: true)
    }
}

extension PresetsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.popularPresets.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.popularPresets.isEmpty ? self.presets.count : section == 0 ? self.popularPresets.count : self.presets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.popularPresets.isEmpty {
            let identifier = "PresetsTableViewCell"
            var cell: PresetsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? PresetsTableViewCell
            if cell == nil
            {
                tableView.register(UINib(nibName: "PresetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PresetsTableViewCell
            }
            
            cell.setupCell(preset: self.presets[indexPath.row], indexPath: indexPath)
            
            cell.blockButtonSelectedHandler = { indexPath in
                let preset = self.presets[indexPath.row]
                self.storePreset(preset)
                self.delegate?.presetSelected(self, preset: preset)
            }
            
            return cell
        } else {
            if indexPath.section == 0 {
                let identifier = "PresetsPopularTableViewCell"
                var cell: PresetsPopularTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? PresetsPopularTableViewCell
                if cell == nil
                {
                    tableView.register(UINib(nibName: "PresetsPopularTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PresetsPopularTableViewCell
                }
                
                cell.setupCell(preset: self.popularPresets[indexPath.row], indexPath: indexPath)
                
                cell.blockButtonSelectedHandler = { indexPath in
                    let preset = self.popularPresets[indexPath.row]
                    self.storePreset(preset)
                    self.delegate?.presetSelected(self, preset: preset)
                }
                
                return cell
            } else {
                let identifier = "PresetsTableViewCell"
                var cell: PresetsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? PresetsTableViewCell
                if cell == nil
                {
                    tableView.register(UINib(nibName: "PresetsTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PresetsTableViewCell
                }
                
                cell.setupCell(preset: self.presets[indexPath.row], indexPath: indexPath)
                
                cell.blockButtonSelectedHandler = { indexPath in
                    let preset = self.presets[indexPath.row]
                    self.storePreset(preset)
                    self.delegate?.presetSelected(self, preset: preset)
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
