//
//  PresetsTableViewCell.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 16/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class PresetsTableViewCell: UITableViewCell {
    @IBOutlet weak var firstDivideView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var blockButtonSelectedHandler:((IndexPath)->Void)?
    
    var preset: Preset!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(preset: Preset, indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.firstDivideView.isHidden = false
        } else {
            self.firstDivideView.isHidden = true
        }
        self.colorView.backgroundColor = preset.setting.flashColor
        self.titleLabel.text = preset.title
        self.descriptionLabel.text = preset.short_description
        self.indexPath = indexPath
    }
    
    @IBAction func selectClicked(_ sender: Any) {
        if(self.blockButtonSelectedHandler != nil){
            self.blockButtonSelectedHandler!(self.indexPath)
        }
    }
}
