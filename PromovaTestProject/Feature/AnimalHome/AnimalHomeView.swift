//
//  AnimalHomeView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import SwiftUI
import ComposableArchitecture

struct AnimalHomeView: View {
    let store: StoreOf<AnimalHomeFeature>

    var body: some View {
        Button {
            
        } label: {
            Text("Label")
        }
    }
}

#Preview {
    AnimalHomeView(store: .init(initialState: AnimalHomeFeature.State()) {
        AnimalHomeFeature()
    })
}
