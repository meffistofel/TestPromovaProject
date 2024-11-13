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
            VStack(spacing: 0) {
                content
            }
            .ignoresSafeArea(edges: .bottom)
            .alert($store.scope(state: \.destination?.alert, action: \.local.destination.alert))
            .overlayEffect(store.isAdShowing)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.appBackground)
            .toastView(toast: $store.toast.sending(\.view.changeToastState))
            .animation(.default, value: store.toast)
        }
    }
}

// MARK: Subviews

private extension AnimalHomeView {
    @ViewBuilder
    var content: some View {
        switch store.viewState {
        case .empty:
            emptyStateView
        case .error(let error):
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                Text(error)
                    .foregroundStyle(.appBlack)
                    .font(.basicTitle)
            }
        case .fetched(let animals):
            listView(animals: animals, isRedacted: false)
                .refreshable {
                    send(.refreshDidEnd)
                }
        case .loading:
            listView(animals: .init(uniqueElements: Animal.mock(maxIndex: 10)), isRedacted: true)
                .allowsHitTesting(false)

        case .none:
            Text("")
                .onAppear {
                    send(.homeDidAppear)
                }
        }
    }

    var emptyStateView: some View {
        VStack(spacing: 16) {
            Text("There are no new items\nplease try requesting later")
                .font(.basicTitle)
                .foregroundStyle(.appBlack)
                .multilineTextAlignment(.center)

            Button {
                send(.homeDidAppear)
            } label: {
                VStack(spacing: 16) {
                    Image(systemName: "goforward")
                    Text("Retry")
                        .font(.basicSubTitle)
                }
            }
            .opacity(store.toast == nil ? 1 : 0)
        }
    }

    func listView(animals: IdentifiedArrayOf<Animal>, isRedacted: Bool) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(animals) { animal in
                    AnimalListItem(model: .init(model: animal), isRedacted: isRedacted)
                        .onTapGesture {
                            handleCellTap(with: animal)
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top)
            .shimmer(when: isRedacted)
        }
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
    AnimalHomeView(store: .init(initialState: AnimalHomeFeature.State(viewState: .loading)) {
        AnimalHomeFeature()
    })
}
