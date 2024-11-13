//
//  OverlayEffectView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

struct OverlayEffectModifier: ViewModifier {
    let isShow: Bool

    func body(content: Content) -> some View {
        content
            .blur(radius: isShow ? 5 : 0)
            .overlay {
                if isShow {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()

                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.appBlack)
                    }
                }
            }
            .animation(.default, value: isShow)
    }
}

extension View {
    func overlayEffect(_ isShow: Bool) -> some View {
        modifier(OverlayEffectModifier(isShow: isShow))
    }
}
