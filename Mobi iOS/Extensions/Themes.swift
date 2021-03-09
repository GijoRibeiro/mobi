//
//  Themes.swift
//  Devium iOS
//
//  Created by Rodrigo Ribeiro on 27.01.21.
//

import Foundation
import UIKit

struct Theme {
    static var appRoundness: CGFloat = 15
    static var generalPadding: CGFloat = 20
    static var primaryColor : UIColor = UIColor(rgb: 0x9568FF)
    static var supportColor : UIColor = UIColor(rgb: 0xEBF2FA)
    static var blackColor : UIColor = UIColor(rgb: 0x0E0E0E)
}

func labelFont (type: UILabel, weight: String, fontSize: CGFloat) {
    if weight == "Regular" {type.font = UIFont(name: "Eina01-Regular", size: fontSize)}
    if weight == "Bold" {type.font = UIFont(name: "Eina01-Bold", size: fontSize)}
    if weight == "Light" {type.font = UIFont(name: "Eina01-Light", size: fontSize)}
    if weight == "Semibold" {type.font = UIFont(name: "Eina01-SemiBold", size: fontSize)}
}

func fieldFont (type: UITextField, weight: String, fontSize: CGFloat) {
    if weight == "Regular" {type.font = UIFont(name: "Eina01-Regular", size: fontSize)}
    if weight == "Bold" {type.font = UIFont(name: "Eina01-Bold", size: fontSize)}
    if weight == "Light" {type.font = UIFont(name: "Eina01-Light", size: fontSize)}
    if weight == "Semibold" {type.font = UIFont(name: "Eina01-SemiBold", size: fontSize)}
}
