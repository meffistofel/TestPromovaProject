//
//  PageCardStyle.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

struct CardStyle {
    var cornerRadius: CGFloat = 6
    var shadow: ShadowModel = .init()
    var fill: Color = .white
    var border: (color: Color, lineWidth: CGFloat) = (.clear, 0)
}
