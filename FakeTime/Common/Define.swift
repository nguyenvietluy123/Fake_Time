//
//  Define.swift
//  Carenefit
//
//  Created by Tony Tuan on 9/4/17.
//  Copyright © 2017 sdc. All rights reserved.
//

import UIKit

let isIPad = DeviceType.IS_IPAD
let heightRatio = (isIPad) ? 1.4 : ScreenSize.SCREEN_HEIGHT/736
let widthRatio = (isIPad) ? 1.4 : ScreenSize.SCREEN_WIDTH/414
let heightDetailCell = (isIPad) ? 55 : 40*heightRatio
let timeZoneApp = 7*60*60
let ctrTopCellDetail = (isIPad) ? 20 : 15*heightRatio
let heightCellContact = (isIPad) ? 60 : 45*heightRatio
let heightTitleCollapse = (isIPad) ? 70 : 50*heightRatio

enum typeCall {
    case call
    case messenger
    case line
    case weChat
}

enum SaveKey: String {
    case countCall = "countCall"
}

class NotificationCenterKey {
    static let SelectedMenu = "SelectedMenu"
    static let DismissAllAlert = "DismissAllAlert"
    static let ReloadMap = "ReloadMap"
}

class Key {
    static let keyMap = "AIzaSyDqXq6POMT9b3bjBqWVYnVRhD_EcSE01-4"
}

class KeyString {
    static let endCall = "End Call"
    
    static let gScary = "G Scary"
    static let ghostClown = "Ghost Clown"
    static let ghostKiller = "Ghost Killer"
    static let ghostScary = "Ghost Scary"
    static let ghost_S = "Ghost_S"
    static let killerClown = "Killer Clown"
    
    
    static let gScarySound = "G Scary.mp3"
    static let ghostClownSound = "Ghost Clown.mp3"
    static let ghostKillerSound = "Ghost Killer.mp3"
    static let ghostScarySound = "Ghost Scary.mp3"
    static let ghost_SSound = "Ghost_S.mp3"
    static let killerClownSound = "Killer Clown.mp3"
    
    static let gScaryVideo = "G Scary.mp4"
    static let ghostClownVideo = "Ghost Clown.mp4"
    static let ghostKillerVideo = "Ghost Killer.mp4"
    static let ghostScaryVideo = "Ghost Scary.mp4"
    static let ghost_SVideo = "Ghost_S.mp4"
    static let killerClownVideo = "Killer Clown.mp4"
    
    static let soundDefault = "call_iphone.mp3"
    static let soundMessenger = "call_messenger.m4a"
    static let soundLine = "call_line.wav"
    static let soundWechat = "call_wechat.mp3"
}

class TColor {
    static let pinkColor = UIColor("D31F46", alpha: 1.0)
    static let greenMainColor = UIColor("00868A", alpha: 1.0)
    static let blackBorderTFColor = UIColor("1D1D26", alpha: 0.1)
    static let blackToolBarColor = UIColor("4F4E4F", alpha: 1.0)
    static let blueBorderCLColor = UIColor("4A90E2", alpha: 1.0)
    static let grayCellColor = UIColor("f1f1f1", alpha: 1.0)
    static let greenMenuSelectedColor = UIColor("C9E5E6", alpha: 1.0)
    static let redMenuSelectedColor = UIColor("A72835", alpha: 1.0)
    static let yellowBackgroundCell = UIColor("fffed1", alpha: 1.0)
}

protocol EnumCollection : Hashable {}
extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
