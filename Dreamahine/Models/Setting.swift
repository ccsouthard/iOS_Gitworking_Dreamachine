//
//  Setting.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 15/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import UIKit

let MainSetting = Setting.shared

class Setting: NSObject {
    static let shared = Setting()
    
    var isSound: Bool = true
    var isLight: Bool = true
    var timer: TimeInterval?
    var isTimer: Bool = false
    
    var noiseType: NoiseType = .none
    var musicUrl: URL?
    
    var brightnessValue: Float = 0.7
    var isFlashing: Bool = false
    var flashColor: UIColor?
    
    func copyValue(setting: Setting) {
        self.isSound = setting.isSound
        self.timer = setting.timer
        self.isTimer = setting.isTimer
        self.noiseType = setting.noiseType
        self.musicUrl = setting.musicUrl
        self.brightnessValue = setting.brightnessValue
        self.isFlashing = setting.isFlashing
        self.flashColor = setting.flashColor
    }
    
    override init()
    {
        super.init()
    }
    
    init(dict:NSDictionary)
    {
        self.isSound = dict.object_forKeyWithValidationForClass_Bool(aKey: "isSound")
        self.isLight = dict.object_forKeyWithValidationForClass_Bool(aKey: "isLight")
        self.timer = Double(dict.object_forKeyWithValidationForClass_Int(aKey: "timer"))
        self.noiseType = NoiseType(rawValue: dict.object_forKeyWithValidationForClass_Int(aKey: "noiseType")) ?? .none
        self.musicUrl = URL(fileURLWithPath:  dict.object_forKeyWithValidationForClass_String(aKey: "musicFile"))
        self.brightnessValue = dict.object_forKeyWithValidationForClass_Float(aKey: "brightnessValue")
        self.isFlashing = dict.object_forKeyWithValidationForClass_Bool(aKey: "isFlashing")
        self.flashColor = UIColor(hexString: dict.object_forKeyWithValidationForClass_String(aKey: "flashColorString")) 
    }
}
