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
        var path = StackState<AnimalDetailFeature.State>()
        var animalList = AnimalHomeFeature.State()
    }
    enum Action {
        case animalList(AnimalHomeFeature.Action)
        case path(StackAction<AnimalDetailFeature.State, AnimalDetailFeature.Action>)
    }

    static var initialStore: StoreOf<Self> = .init(initialState: Self.State()) { Self() }

    var body: some ReducerOf<Self> {
        Scope(state: \.animalList, action: \.animalList) {
            AnimalHomeFeature()
        }
        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .output(action))):
                switch action {
                case .onBackDidTap:
                    return .send(.animalList(.input(.fetchAnimals)))
                }
            case let .animalList(.delegate(.onCellDidTap(detailState))):
                state.path.append(detailState)

                return .none
            case .animalList:
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            AnimalDetailFeature()
        }
    }
}

