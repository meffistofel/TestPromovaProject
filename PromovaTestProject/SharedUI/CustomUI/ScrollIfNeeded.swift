//
//  ScrollIfNeeded.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/13/24.
//

import SwiftUI

struct ScrollIfNeeded<Content: View>: View {

    var isNeedScroll: Bool
    let content: () -> Content

    init(isNeedScroll: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.isNeedScroll = isNeedScroll
    }

    var body: some View {
        if isNeedScroll {
            ScrollView(showsIndicators: false) {
                content()
            }
        } else {
            content()
        }
    }
}
