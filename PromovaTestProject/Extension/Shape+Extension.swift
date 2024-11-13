//
//  Shape+Extension.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill,
        strokeBorder strokeStyle: Stroke,
        lineWidth: Double = 1
    ) -> some View {

        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(
        _ fillStyle: Fill,
        strokeBorder strokeStyle: Stroke,
        lineWidth: Double = 1
    ) -> some View {

        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
