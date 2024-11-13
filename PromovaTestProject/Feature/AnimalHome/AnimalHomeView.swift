//
//  AnimalHomeView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: AnimalHomeFeature.self)
struct AnimalHomeView: View {
    @Perception.Bindable var store: StoreOf<AnimalHomeFeature>

    var body: some View {
        WithPerceptionTracking {
            content
                .ignoresSafeArea(edges: .bottom)
                .alert($store.scope(state: \.destination?.alert, action: \.local.destination.alert))
                .overlayEffect(store.isAdShowing)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.appBackground)
        }
    }
}

// MARK: Subviews

private extension AnimalHomeView {
    @ViewBuilder
    var content: some View {
        switch store.viewState {
        case .empty:
            Text("There are no new items\nplease try requesting later")
                .font(.basicTitle)
                .foregroundStyle(.appBlack)
                .multilineTextAlignment(.center)
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
                .refreshable {
                    send(.refreshDidEnd)
                }
        case .loading:
            listView(animals: .init(uniqueElements: Animal.mock(maxIndex: 10)))
                .shimmer(when: true)
                .allowsHitTesting(false)
        case .none:
            Text("")
                .onAppear {
                    send(.homeDidAppear)
                }
        }
    }

    func listView(animals: IdentifiedArrayOf<Animal>) -> some View {
        List(animals) { animal in
            AnimalListItem(model: .init(model: animal))
                .onTapGesture {
                    handleCellTap(with: animal)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .padding(.top, 1)
    }
}

extension AnimalHomeView {
    private func handleCellTap(with animal: Animal) {

        guard let content = animal.content else {
            send(.didTapToComingSoonContent)
            return
        }

        guard animal.status.isAvailable else {
            send(.didTapToPaidContent(animal.title, content))
            return
        }

        send(.cellDidTap(animal.title, content))
    }
}

#Preview {
    AnimalHomeView(store: .init(initialState: AnimalHomeFeature.State(viewState: .empty)) {
        AnimalHomeFeature()
    })
}
