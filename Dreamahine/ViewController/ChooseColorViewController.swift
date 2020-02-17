//
//  ChooseColorViewController.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit
protocol ChooseColorViewControllerDelegate: class {
    func cancelClicked(_ controller: ChooseColorViewController)
    func setColorClicked(_ controller: ChooseColorViewController, color: UIColor?)
}

class ChooseColorViewController: UIViewController {
    @IBOutlet weak var chooseColorView: UIView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var colorDescriptionLabel: UILabel!
    
    weak var delegate: ChooseColorViewControllerDelegate?
    var selectedColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.doSetupCollectionView()
    }
    func setupChooseColor(color: UIColor?) {
        if let color = color {
            self.selectedColor = color
            self.colorCollectionView.reloadData()
        }
        
        self.chooseColorView.frame.origin.y = self.view.frame.size.height
        
        UIView.animate(withDuration: 0.5, animations: {
            self.chooseColorView.frame.origin.y = self.view.frame.size.height - self.chooseColorView.frame.size.height - 21
        }) { (finished) in            
        }
    }
    
    private func hideChooseColor(cancel: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.chooseColorView.frame.origin.y = self.view.frame.size.height
        }) { (finished) in
            if cancel {
                self.delegate?.cancelClicked(self)
            } else {
                self.delegate?.setColorClicked(self, color: self.selectedColor)
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        hideChooseColor(cancel: true)
    }
    
    @IBAction func setColorClicked(_ sender: Any) {
        hideChooseColor(cancel: false)
    }
}

extension ChooseColorViewController {
    private func doSetupCollectionView() {
        self.colorCollectionView.register(UINib(nibName: "ChooseColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: self.colorCollectionView.frame.width / 4, height: self.colorCollectionView.frame.width / 4)
        self.colorCollectionView.collectionViewLayout = flowLayout
        
        self.colorCollectionView.backgroundColor = .clear
    }
}
extension ChooseColorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return COLORS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as! ChooseColorCollectionViewCell
        let color = UIColor(hexString: COLORS[indexPath.row])
        cell.colorView.backgroundColor = color
        if let selectedColor = self.selectedColor, selectedColor.isEqual(color) {
            cell.checkImage.isHidden = false
        } else {
            cell.checkImage.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedColor = UIColor(hexString: COLORS[indexPath.row])
        self.colorCollectionView.reloadData()
    }
}
