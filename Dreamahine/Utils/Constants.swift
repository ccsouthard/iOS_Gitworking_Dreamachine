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

let FREQUENCY_DESCRIPTION: [String: String] = [
    "delta": "Delta: Deep Sleep",
    "theta": "Theta: Hypnagogic Imagery/Meditation",
    "alpha": "Alpha: Creativity/Meditation",
    "beta" : "Beta: Concentration",
    "gamma": "Gamma: Problem Solving"
]

let COLORS: [String] = [
    "00A7F7",
    "3E4EB8",
    "6734BA",
    "00BCD6",
    "47B04B",
    "FFED18",
    "FEC100",
    "FE9800",
    "EC1561",
    "9D1BB2",
    "212121",
    "9E9E9E"
]

let mainBlackColor:String = "99000000"
enum FrequencyType: Int
{
    case
    delta,
    theta,
    alpha,
    beta,
    gamma,
    none

    var title: String
    {
        switch self
        {
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
    
    var maxFrequency: Float
    {
        switch self
        {
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
}
