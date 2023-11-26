//
//  File.swift
//  
//
//  Created by islam Awaad on 26/11/2023.
//

import Foundation
import SwiftUI

public enum IBMPlexSansFontFilesName: String, CaseIterable {
    case bold = "IBMPlexSansArabic-Bold"
    case extraLight = "IBMPlexSansArabic-ExtraLight"
    case light = "IBMPlexSansArabic-Light"
    case medium = "IBMPlexSansArabic-Medium"
    case regular = "IBMPlexSansArabic-Regular"
    case semiBold = "IBMPlexSansArabic-SemiBold"
    case text = "IBMPlexSansArabic-Text"
    
}


public func registerFonts() {
    IBMPlexSansFontFilesName.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "otf")
    }
}

public func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
    guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
          let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
          let font = CGFont(fontDataProvider) else {
        fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
    }

    var error: Unmanaged<CFError>?
    CTFontManagerRegisterGraphicsFont(font, &error)
}



public extension Font {

    static let regularText:Font = .custom(IBMPlexSansFontFilesName.text.rawValue, size: 12)
    static let semiBoldLargeTitle:Font = .custom(IBMPlexSansFontFilesName.semiBold.rawValue, size: 22)
    static let RegularTitle:Font = .custom(IBMPlexSansFontFilesName.text.rawValue, size: 15)
    static let semiBoldName:Font = .custom(IBMPlexSansFontFilesName.semiBold.rawValue, size: 12)
    static let RegularSmallText:Font = .custom(IBMPlexSansFontFilesName.text.rawValue, size: 10)
}
