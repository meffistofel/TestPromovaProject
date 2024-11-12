//
//  AnimalHomeFeature.swift
//  PromovaTestProject
//
//  Created by Alex Kovalov on 11/12/24.
//

import ComposableArchitecture

@Reducer
struct AnimalHomeFeature {

    private let environment: AnimalHomeEnvironment = .init()

    @ObservableState
    struct State: Equatable {
        var viewState: ViewState = .none

    }
    enum Action {
        case delegate(Delegate)
        case homeDidAppear
        case refreshDidEnd
        case animalResponse(Result<IdentifiedArrayOf<Animal>, Error>)
    }

    enum Delegate: Equatable {
        case cellDidTap([AnimalContent])
    }

    enum ViewState: Equatable {
        case none
        case empty
        case loading
        case error(String)
        case fetched(IdentifiedArrayOf<Animal>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .homeDidAppear, .refreshDidEnd:
                return .run { send in
                    try await send(.animalResponse(.success(environment.animalCachedService.fetchAnimals())))
                } catch: { error, send in
                    await send(.animalResponse(.failure(error)))
                }
            case .animalResponse(.success(let animals)):
                state.viewState = animals.isEmpty ? .empty : .fetched(animals)

                return .none

            case .animalResponse(.failure(let error)):
                state.viewState = .error(error.localizedDescription)

                return .none

            case .delegate:
                return .none
            }
        }
    }
}
