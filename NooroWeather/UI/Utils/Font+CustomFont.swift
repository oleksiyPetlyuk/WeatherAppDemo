//
//  Font+CustomFont.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import SwiftUI

enum FontWeight {
    case regular
    case medium
    case semiBold
}

extension Font {
    static func poppins(_ weight: FontWeight, _ size: CGFloat) -> Font {
        switch weight {
        case .regular:
            Font.custom("Poppins-Regular", size: size)
        case .medium:
            Font.custom("Poppins-Medium", size: size)
        case .semiBold:
            Font.custom("Poppins-SemiBold", size: size)
        }
    }
}
