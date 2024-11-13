//
//  AnimalDetailView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import SwiftUI
import ComposableArchitecture

private extension CGFloat {
    static let imageHeight: CGFloat = .relative(to: .height, value: 234)
    static let cellCornerRadius: CGFloat = 6
}

@ViewAction(for: AnimalDetailFeature.self)
struct AnimalDetailView: View {
    @Perception.Bindable var store: StoreOf<AnimalDetailFeature>

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                header
                #warning("TODO: This is an approach that I developed independently a year ago, inspired by various data, the disadvantages are that it is difficult to work out lazy states, but due to the limited time for execution, it is the best that I can offer,")
                PageContainer(
                    currentIndex: $store.currentIndex.sending(\.view.changeIndexWithSwipe),
                    listItem: store.content.elements,
                    headerContent: { model in
                        AsyncImageApp(url: model.item.image, height: .imageHeight)
                            .padding(.top, 10)
                            .padding(.bottom, 17)
                    },
                    listContent: { model in
                        Text(model.item.fact)
                            .font(.basicFact)
                            .foregroundStyle(.appBlack)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    },
                    listFooter: { model in
                        let backwardIsAvailable = model.index > 0
                        let forwardIsAvailable = model.index < store.content.elements.count - 1
                        
                        AnimalDetailActionButtonView(
                            backwardIsAvailable: backwardIsAvailable,
                            forwardIsAvailable: forwardIsAvailable,
                            onEvent: handleAnimalDetailCardEvent(for: )
                        )
                        .padding(.horizontal, 12)
                        .padding(.bottom, 20)
                    }
                )
            }
            .animation(.default, value: store.currentIndex)
            .padding(.bottom)
            .ignoresSafeArea(edges: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.appBackground)
            .navigationBarHidden(true)
        }
    }
}

extension AnimalDetailView {
    var header: some View {
        Text(store.category)
            .font(.basicNavigationTitle)
            .foregroundStyle(.appBlack)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .relative(to: .height, value: 90), alignment: .bottom)
            .overlay(alignment: .leadingLastTextBaseline) {
                Button {
                    send(.backDidTap)
                } label: {
                    Image(.iconArrow)
                }
                .padding(.leading, 15)

            }
            .overlay(alignment: .trailingLastTextBaseline) {
                let currentItem = store.currentItem
                
                ShareLink(
                    item: currentItem.image,
                    subject: Text(store.category),
                    message: Text(currentItem.fact)
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.appBlack)
                }
                .padding(.trailing, 15)
            }
            .padding(.bottom, 28)
            .compositingGroup()
            .background {
                Rectangle()
                    .fill(.appBackground)
                    .shadow(color: .appBlack.opacity(0.25), radius: 4, x: 0, y: 4)
            }
            .zIndex(1000)
    }
}

extension AnimalDetailView {
    private func handleAnimalDetailCardEvent(for event: AnimalDetailActionButtonView.Event) {
        switch event {
        case .didTapBackward:
            send(.didTapBackward)
        case .didTapForward:
            send(.didTapForward)
        }
    }
}

#Preview {
    AnimalDetailView(
        store: .init(
            initialState: AnimalDetailFeature.State(
                category: "Cats",
                content: .init(uniqueElements: AnimalContent.mock())
            )
        ) {
            AnimalDetailFeature()
        })
}
