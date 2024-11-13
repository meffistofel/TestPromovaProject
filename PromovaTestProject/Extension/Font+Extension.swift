//
//  Font+Extension.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import SwiftUI
import UIKit
import OSLog

private let logger = Logger(subsystem: "PromovaTestProject", category: "Font+Extension")

enum FontType: String {
  case basic

  var name: String {
    self.rawValue.capitalized
  }
}

enum FontWeight: String {
  case extraLight
  case light
  case thin
  case regular
  case medium
  case semiBold
  case bold
  case extraBold
  case black

  case extraLightItalic
  case lightItalic
  case thinItalic
  case regularItalic
  case mediumItalic
  case semiBoldItalic
  case boldItalic
  case extraBoldItalic
  case blackItalic

  var name: String {
    "-" + self.rawValue.capitalized
  }
}


extension Font {
  /// Use this method for custom fonts with variable weight and style.
  /// Dynamically updates the font size with the system size.
  /// - Parameters:
  ///   - type: Cases that describe the preferred type of font.
  ///   - weight: Cases that describe the preferred weight for fonts.
  ///   - style: Constants that describe the preferred styles for fonts.
  /// - Returns: Custom font based on the parameters you specified.
  static private func font(type: FontType, weight: FontWeight, style: UIFont.TextStyle) -> Font {
    .custom(type.name + weight.name, size: UIFont.preferredFont(forTextStyle: style).pointSize)
  }

  /// Use this method for custom fonts with variable weight and size.
  /// Dynamically updates the font size with the system size.
  /// - Parameters:
  ///   - type: Cases that describe the preferred type of font.
  ///   - weight: Cases that describe the preferred weight for fonts.
  ///   - size: Constants that describe the preferred size for fonts.
  /// - Returns: Custom font based on the parameters you specified.
    static fileprivate func font(type: FontType, weight: FontWeight, size: CGFloat) -> Font {
        if UIFont(name: type.name + weight.name, size: size) == nil {
            logger.error("\(type.name + weight.name) font doesn't exist")
        }

        return .custom(type.name + weight.name, size: size)
    }
}

extension UIFont {
  static func font(type: FontType, weight: FontWeight, size: CGFloat) -> UIFont {
    UIFont(name: type.name + weight.name, size: size)!
  }
}

extension View {
    func fontApp(type: FontType = .basic, weight: FontWeight, size: CGFloat) -> some View {
    self
      .font(.custom(type.name + weight.name, size: size))
  }
}

extension Font {

    /// Basic regular 18px
    static let basicFact = font(type: .basic, weight: .regular, size: 18)

    /// Basic regular 17px
    static let basicNavigationTitle = font(type: .basic, weight: .regular, size: 17)

    /// Basic regular 16px
    static let basicTitle = font(type: .basic, weight: .regular, size: 16)

    /// Basic regular 12px
    static let basicSubTitle = font(type: .basic, weight: .regular, size: 12)
}
