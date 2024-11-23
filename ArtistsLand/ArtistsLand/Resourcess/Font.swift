//
//  Font.swift
//  ArtistsLand
//
//  Created by Alexia Aldea on 17.10.2024.
//

import Foundation
import SwiftUI

fileprivate enum PoppinsFontNames: String {
    case bold = "Poppins-Bold"
    case semiBold = "Poppins-SemiBold"
    case regular = "Poppins-Regular"
}

extension Font {
    static func poppinsBold(size: CGFloat) -> Font {
        return Font.custom(PoppinsFontNames.bold.rawValue, size: size)
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom(PoppinsFontNames.regular.rawValue, size: size)
    }
        
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return Font.custom(PoppinsFontNames.semiBold.rawValue, size: size)
    }
}
