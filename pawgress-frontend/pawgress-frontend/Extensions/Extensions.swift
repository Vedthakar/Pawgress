//
//  Extensions.swift
//  pawgress-frontend
//
//  Created by Krisha Patel on 2025-10-10.
//

import SwiftUI

// MARK: - UIColor Extension (UIKit)
extension UIColor {
    static let sunflowerSubtle = UIColor(red: 253/255, green: 245/255, blue: 183/255, alpha: 1)

    static let paleYellow    = UIColor(red: 235/255, green: 237/255, blue: 3/255, alpha: 1)    // #EBED03
    static let sunflower     = UIColor(red: 244/255, green: 211/255, blue: 94/255, alpha: 1)   // #F4D35E

    static let coralPink     = UIColor(red: 234/255, green: 65/255,  blue: 103/255, alpha: 1)  // #EA4167
    static let peachOrange   = UIColor(red: 247/255, green: 135/255, blue: 100/255, alpha: 1)  // #F78764
    
    static let oliveGold     = UIColor(red: 185/255, green: 156/255, blue: 52/255, alpha: 1)   // #B99C34
    static let lightCream    = UIColor(red: 255/255, green: 255/255, blue: 221/255, alpha: 1)  // #FFFFDD
    
    static let ivoryWhite = UIColor(red: 254/255, green: 254/255, blue: 237/255, alpha: 1)  // #FEFEED

}

// MARK: - Color Extension (SwiftUI)
extension Color {
    static let sunflowerSubtle = Color(red: 253/255, green: 245/255, blue: 183/255)

    
    static let paleYellow    = Color(red: 235/255, green: 237/255, blue: 3/255)    // #EBED03
    static let coralPink     = Color(red: 234/255, green: 65/255,  blue: 103/255)  // #EA4167
    
    static let sunflower     = Color(red: 244/255, green: 211/255, blue: 94/255)   // #F4D35E
    static let peachOrange   = Color(red: 247/255, green: 135/255, blue: 100/255)  // #F78764
    
    static let oliveGold     = Color(red: 185/255, green: 156/255, blue: 52/255)   // #B99C34
    static let lightCream    = Color(red: 255/255, green: 255/255, blue: 221/255)  // #FFFFDD
    
    static let ivoryWhite = Color(red: 254/255, green: 254/255, blue: 237/255)  // #FEFEED

}

//Font text-style extension
extension Font.TextStyle {
    //Function helps DMSans extension
    func toUIFontTextStyle() -> UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        @unknown default: return .body
        }
        //Most redundant cases
    }
}

//Font extension
extension Font {
    static func DMSansS(_ size: CGFloat) -> Font {
        return .custom("DMSans-Regular", size: size)
    }
    static func DMSans(_ style: TextStyle) -> Font {
        return .custom("DMSans-Regular", size: UIFont.preferredFont(forTextStyle: style.toUIFontTextStyle()).pointSize, relativeTo: style)
    }
    
    static func PixelS(_ size: CGFloat) -> Font {
        return .custom("PixelifySans-Regular", size: size)
    }
    static func Pixel(_ style: TextStyle) -> Font {
        return .custom("PixelifySans-Regular", size: UIFont.preferredFont(forTextStyle: style.toUIFontTextStyle()).pointSize, relativeTo: style)
    }
   
}
