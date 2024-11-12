//
//  AnimalHomeFeature.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import ComposableArchitecture

@Reducer
struct AnimalHomeFeature {
    @ObservableState
    struct State: Equatable {

    }
    enum Action {
        case none
    }

    @Dependency(\.animalAPIService) private var animalAPIService

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .none:
              return .none
            }
        }
    }
}
