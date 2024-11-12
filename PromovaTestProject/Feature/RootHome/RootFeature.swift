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
    }
    enum Action {
        case path(StackActionOf<Path>)
    }

    @Reducer(state: .equatable)
    enum Path {
        case detailItem
    }

    var body: some ReducerOf<Self> {

        Reduce { state, action in
            switch action {
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

