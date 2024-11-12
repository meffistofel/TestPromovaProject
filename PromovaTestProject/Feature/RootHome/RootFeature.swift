//
//  RootFeature.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var animalList = AnimalHomeFeature.State()
    }
    enum Action {
        case animalList(AnimalHomeFeature.Action)
        case path(StackActionOf<Path>)
    }

    @Reducer(state: .equatable)
    enum Path {
        case detailItem(AnimalDetailFeature)
    }

    static var initialStore: StoreOf<Self> = .init(initialState: Self.State()) { Self() }

    var body: some ReducerOf<Self> {
        Scope(state: \.animalList, action: \.animalList) {
            AnimalHomeFeature()
        }
        Reduce { state, action in
            switch action {
            case .path:
                return .none
            case let .animalList(.delegate(.cellDidTap(animalContent))):
                state.path.append(.detailItem(AnimalDetailFeature.State(content: animalContent)))
                return .none
            case .animalList:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

