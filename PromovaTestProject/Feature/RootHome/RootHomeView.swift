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
                    destinationView(store: $0)
                }
        }
    }

    @ViewBuilder
    private func destinationView(store: Store<RootFeature.Path.State, RootFeature.Path.Action>) -> some View {
        switch store.case {
        case .detailItem(let store):
            AnimalDetailView(store: store)
        }
    }
}

#Preview {
    RootHomeView(store: Store(initialState: RootFeature.State()) {
        RootFeature()
    })
}
