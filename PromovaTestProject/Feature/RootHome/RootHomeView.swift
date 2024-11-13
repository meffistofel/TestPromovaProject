//
//  HomeFlowView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import SwiftUI
import ComposableArchitecture

struct RootHomeView: View {

    @Perception.Bindable var store: StoreOf<RootFeature>

    var body: some View {
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(state: \.path, action: \.path)) {
                    AnimalHomeView(store: store.scope(state: \.animalList, action: \.animalList))
                } destination: {
                    AnimalDetailView(store: $0)
                }
        }
    }
}

#Preview {
    RootHomeView(store: Store(initialState: RootFeature.State()) {
        RootFeature()
    })
}
