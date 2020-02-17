//
//  ChooseColorCollectionViewCell.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class ChooseColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.colorView.cornerRadius = self.colorView.frame.width / 2
    }
}
