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
    func presetSelected(_ controller: PresetsViewController, date: Date)
}

class PresetsViewController: UIViewController {
    @IBOutlet weak var presetsView: UIView!
    weak var delegate: PresetsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.hidePresets(cancel: true)
    }
}
