//
//  PrintConstraints.swift
//  Mobi iOS
//
//  Created by Rodrigo Ribeiro on 09.02.21.
//

import Foundation
import UIKit

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
