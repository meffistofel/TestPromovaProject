//
//  ListView.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import SwiftUI
import ComposableArchitecture

struct AnimaListView: View {
    enum Event {
        case paginationHasBeenCalled(Animal)
        case didTapToRow(Animal)
    }

    let isLoading: Bool
    let animals: IdentifiedArrayOf<Animal>
    let onEvent: (Event) -> Void

    var body: some View {
        List(animals) { animal in
            AnimalListItem(model: .init(model: animal))
                .onTapGesture { onEvent(.didTapToRow(animal)) }
                .onAppear { onEvent(.paginationHasBeenCalled(animal)) }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .toolbar {
            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    AnimaListView(
        isLoading: false,
        animals: IdentifiedArrayOf(uniqueElements: Animal.mock(maxIndex: 10)),
        onEvent: { _ in }
    )
    .background(.appBackground)
}
