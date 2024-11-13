//
//  PageCounterStyle.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

extension PageCounter {
    enum MaxDotCount {
        case three
        case five

        var additionalDot: Int {
            switch self {
            case .three:
                return 1
            case .five:
                return 2
            }
        }

        var isNeedAdditionalScale: Bool {
            switch self {
            case .three:
                return false
            case .five:
                return true
            }
        }
    }
    struct Style {
        var primaryColor = Color.black
        var secondaryColor = Color.black.opacity(0.6)
        var circleSize: CGFloat = 16
        var circleSpacing: CGFloat = 12
        var smallScale = 0.6
        var maxDotCounts: MaxDotCount = .five
        var isVisible: Bool = true
    }
}
