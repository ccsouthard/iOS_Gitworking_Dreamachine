//
//  Preset.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 16/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import Foundation

class Preset: NSObject {
    var title: String = ""
    var short_description: String = ""
    var setting: Setting = Setting()
    
    override init()
    {
        super.init()
    }
    
    init(dict:NSDictionary)
    {
        self.title = dict.object_forKeyWithValidationForClass_String(aKey: "title")
        self.short_description = dict.object_forKeyWithValidationForClass_String(aKey: "description")
        self.setting = Setting(dict: dict.object_forKeyWithValidationForClass_NSDictionary(aKey: "setting"))
    }
}
