//
//  MainViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 13/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var alphaBackgroundView: UIView!
    @IBOutlet weak var betaBackgroundView: UIView!
    @IBOutlet weak var gammaBackgroundView: UIView!
    @IBOutlet weak var presetsView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var controlView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("scrollview offset = \(scrollView.contentOffset)")
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    @IBAction func timerClicked(_ sender: Any) {
    }
    @IBAction func settingsClicked(_ sender: Any) {
    }
    @IBAction func changePresetClicked(_ sender: Any) {
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
}
