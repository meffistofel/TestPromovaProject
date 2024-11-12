//
//  AnimalDetailView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import SwiftUI
import ComposableArchitecture

struct AnimalDetailView: View {
    let store: StoreOf<AnimalDetailFeature>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AnimalDetailView(store: .init(initialState: AnimalDetailFeature.State()) {
        AnimalDetailFeature()
    })
}
