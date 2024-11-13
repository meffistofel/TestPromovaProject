//
//  PageCardShadow.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

struct ShadowModel {
    let color: Color = .appBlack.opacity(0.3)
    let radius: CGFloat = 60
    let position: CGPoint = .init(x: 0, y: 20)
}

extension View {
    func cardShadow(with model: ShadowModel) -> some View {
        shadow(
            color: model.color,
            radius: model.radius,
            x: model.position.x,
            y: model.position.y
        )
    }
}
