//
//  Label+Style.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import SwiftUI

extension LabelStyle where Self == AdaptiveLabelStyle {
    static func adaptive(
        iconAlignment: AdaptiveLabelStyle.IconAlignment = .leading,
        spacing: CGFloat = 8
    ) -> AdaptiveLabelStyle {
        .init(iconAlignment: iconAlignment, spacing: spacing)
    }
}

struct AdaptiveLabelStyle: LabelStyle {
    enum IconAlignment {
        case leading
        case trailing
        case top
        case bottom
    }

    var iconAlignment: IconAlignment
    var spacing: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        Group {
            switch iconAlignment {
            case .leading:
                HStack(spacing: spacing) {
                    configuration.icon
                    configuration.title
                }
            case .trailing:
                HStack(spacing: spacing) {
                    configuration.title
                    configuration.icon
                }
            case .top:
                VStack(spacing: spacing) {
                    configuration.icon
                    configuration.title
                }
            case .bottom:
                VStack(spacing: spacing) {
                    configuration.title
                    configuration.icon
                }
            }
        }
    }
}
