//
//  Constants.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 14/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import Foundation

let CHANNEL_COUNTS: UInt32 = 5
let FREQUENCY_MAX: Float = 46.0
let FREQUENCY_MIN: Float = 1.0

let THRESHOLD_DELTA_THETA: Float = 4.0
let THRESHOLD_THETA_ALPHA: Float = 8.0
let THRESHOLD_ALPHA_BETA: Float = 12.0
let THRESHOLD_BETA_GAMMA: Float = 40.0

let MAIN_BLACK_COLOR: String = "99000000"

let STRING_USED_PRESETS: String = "used_presets"

let FREQUENCY_DESCRIPTION: [String: String] = [
    "delta": "Delta: Deep Sleep",
    "theta": "Theta: Hypnagogic Imagery/Meditation",
    "alpha": "Alpha: Creativity/Meditation",
    "beta" : "Beta: Concentration",
    "gamma": "Gamma: Problem Solving"
]

let COLORS: [String] = [
    "FF7272",
    "FF9272",
    "FFC772",
    "EBE325",
    "90D31C",
    "21D67F",
    "32D4D8",
    "70BDF8",
    "3D86F1",
    "9F87FD",
    "CB87FD",
    "FC79D7"
]


enum FrequencyType: Int
{
    case
    delta,
    theta,
    alpha,
    beta,
    gamma,
    none

    var title: String {
        switch self {
        case .delta:
            return "δ"
        case .theta:
            return "θ"
        case .alpha:
            return "α"
        case .beta:
            return "β"
        case .gamma:
            return "γ"
        default:
            return ""
        }
    }
    
    var maxFrequency: Float {
        switch self {
        case .delta:
            return 4.0
        case .theta:
            return 8.0
        case .alpha:
            return 12.0
        case .beta:
            return 40.0
        case .gamma:
            return 46.0
        default:
            return 1.0
        }
    }
    
    var description: String {
        switch self {
        case .delta:
            return "Delta"
        case .theta:
            return "Theta"
        case .alpha:
            return "Alpha"
        case .beta:
            return "Beta"
        case .gamma:
            return "Gamma"
        default:
            return ""
        }
    }
}

enum NoiseType: Int {
    case
    pink,
    white,
    rain,
    none
    
    var title: String {
        switch self {
        case .pink:
            return "Pink Noise"
        case .white:
            return "White Noise"
        case .rain:
            return "Rain Noise"
        case .none:
            return ""
        }
    }
    
    var fileName: String {
        switch self {
        case .pink:
            return "Sounds/pink_noise"
        case .white:
            return "Sounds/white_noise"
        case .rain:
            return "Sounds/rain_noise"
        case .none:
            return ""
        }
    }
    
    var fileType: String {
        switch self {
        case .pink:
            return "wav"
        case .white:
            return "wav"
        case .rain:
            return "mp3"
        case .none:
            return ""
        }
    }
}

