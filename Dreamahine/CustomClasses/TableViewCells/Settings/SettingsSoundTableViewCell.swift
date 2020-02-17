//
//  SettingsSoundTableViewCell.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class SettingsSoundTableViewCell: UITableViewCell {
    @IBOutlet weak var pinkNoiseLabel: UILabel!
    @IBOutlet weak var whiteNoiseLabel: UILabel!
    @IBOutlet weak var rainNoiseLabel: UILabel!
    
    @IBOutlet weak var pinkNoiseCheckedImage: UIImageView!
    @IBOutlet weak var whiteNoiseCheckedImage: UIImageView!
    @IBOutlet weak var rainNoiseCheckedImage: UIImageView!
    
    @IBOutlet weak var musicTitleLabel: UILabel!
    
    var blockNoiseTypeSelectedHandler:((NoiseType)->Void)?
    var blockButtonMusicOpenHandler:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(setting: Setting) {
        self.pinkNoiseLabel.textColor = UIColor(hexString: MAIN_BLACK_COLOR)
        self.whiteNoiseLabel.textColor = UIColor(hexString: MAIN_BLACK_COLOR)
        self.rainNoiseLabel.textColor = UIColor(hexString: MAIN_BLACK_COLOR)
        
        self.pinkNoiseCheckedImage.isHidden = true
        self.whiteNoiseCheckedImage.isHidden = true
        self.rainNoiseCheckedImage.isHidden = true
        
        switch setting.noiseType {
        case .pink:
            self.pinkNoiseLabel.textColor = .white
            self.pinkNoiseCheckedImage.isHidden = false
        case .white:
            self.whiteNoiseLabel.textColor = .white
            self.whiteNoiseCheckedImage.isHidden = false
        case .rain:
            self.rainNoiseLabel.textColor = .white
            self.rainNoiseCheckedImage.isHidden = false
        default:
            break
        }
        
        if let musicUrl = setting.musicUrl {
            self.musicTitleLabel.text = musicUrl.lastPathComponent
        } else {
            self.musicTitleLabel.text = ""
        }
    }
    
    @IBAction func noiseTypeSelected(_ sender: UIButton) {
        if(self.blockNoiseTypeSelectedHandler != nil){
            self.blockNoiseTypeSelectedHandler!(NoiseType(rawValue: sender.tag) ?? .none)
        }
    }
    
    @IBAction func musicClicked(_ sender: Any) {
        if(self.blockButtonMusicOpenHandler != nil){
            self.blockButtonMusicOpenHandler!()
        }
    }
}
