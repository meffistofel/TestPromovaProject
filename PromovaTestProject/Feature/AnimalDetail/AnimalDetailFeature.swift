//
//  AnimalDetailFeature.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/11/24.
//

import ComposableArchitecture

@Reducer
struct AnimalDetailFeature {
    @ObservableState
    struct State: Equatable {

    }
    enum Action {
        case none
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .none:
              return .none
            }
        }
    }
}
