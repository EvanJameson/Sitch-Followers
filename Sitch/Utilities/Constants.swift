//
//  Constants.swift
//  Sitch
//
//  Created by Evan Jameson on 6/25/20.
//  Copyright © 2020 Evan Jameson. All rights reserved.
//

import UIKit

enum Limits {
    static let followersPerPage         = 100
    static let streamsPerPage           = 10
}


enum Colors {
    static let baseText                 = UIColor(named: "base-text")
}


enum SFSymbols {
    static let normalUser               = UIImage(systemName: "person")
    static let affiliate                = UIImage(systemName: "person.2")
    static let partner                  = UIImage(systemName: "person.3")
}


enum Images {
    static let avatarPlaceholder        = UIImage(named: "avatar-placeholder")
    static let backgroundPlaceholder    = UIImage(named: "background-placeholder")
    static let sitchLogo                = UIImage(named: "sitch-logo")
    static let emptyState               = UIImage(named: "empty-state-logo")
    static let live                     = UIImage(named: "live")
    static let offline                  = UIImage(named: "offline")
}


enum ScreenSize {
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let maxLength                = max(ScreenSize.width, ScreenSize.height)
    static let minLength                = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhoneSE2ndGen         = idiom == .phone && ScreenSize.maxLength == 667.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength == 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
