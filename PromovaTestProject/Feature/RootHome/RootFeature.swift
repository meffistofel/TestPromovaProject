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
            case let .path(.element(id: _, action: action)):
                switch action {

                case .detailItem(let action):
                    switch action {
                    case .output(.onBackDidTap):
                        return .send(.animalList(.input(.fetchAnimals)))
                    default:
                        return .none
                    }
                }
            case let .animalList(.delegate(.onCellDidTap(detailState))):
                state.path.append(.detailItem(detailState))

                return .none
            case .animalList:
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

