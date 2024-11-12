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
        WithPerceptionTracking {
            content
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: Subviews

private extension AnimalHomeView {
    @ViewBuilder
    var content: some View {
        switch store.viewState {
        case .error(let error):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                Text(error)
                    .foregroundStyle(.appBlack)
                    .font(.basicTitle)
            }
        case .fetched(let animals):
            listView(animals: animals)
        case .loading:
            listView(animals: .init(uniqueElements: Animal.mock(maxIndex: 10)))
                .shimmer(when: true)
                .allowsHitTesting(false)
        case .none:
            Text("")
                .onAppear {
                    store.send(.homeDidAppear)
                }
        }
    }

    func listView(animals: IdentifiedArrayOf<Animal>) -> some View {
        List(animals) { animal in
            AnimalListItem(model: .init(model: animal))
                .onTapGesture { }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .padding(.top, 1)
    }
}

#Preview {
    AnimalHomeView(store: .init(initialState: AnimalHomeFeature.State(viewState: .loading)) {
        AnimalHomeFeature()
    })
}
