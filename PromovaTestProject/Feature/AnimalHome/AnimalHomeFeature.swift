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
        @Presents var destination: Destination.State?
        var isAdShowing: Bool = false
        var viewState: ViewState = .none
    }
    
    enum Action {
        case delegate(Delegate)
        case homeDidAppear
        case refreshDidEnd
        case didTapToPaidContent([AnimalContent])
        case didTapToComingSoonContent
        case animalResponse(Result<IdentifiedArrayOf<Animal>, Error>)
        case destination(PresentationAction<Destination.Action>)
        case startAd
        case finishAd

        enum Alert: Equatable {
            case showAD([AnimalContent])
        }
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

            case let .didTapToPaidContent(content):
                state.destination = .alert(.showAD(animalContent: content))
                return .none

            case .didTapToComingSoonContent:
                state.destination = .alert(.comingSoon)
                return .none

            case let .destination(.presented(.alert(.showAD(content)))):
                return .run { send in
                    await send(.startAd)
                    try? await environment.clock.sleep(for: .seconds(2))
                    await send(.finishAd)
                    await send(.delegate(.cellDidTap(content)))
                }
            case .startAd:
                state.isAdShowing = true

                return .none

            case .finishAd:
                state.isAdShowing = false

                return .none

            case .destination:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension AnimalHomeFeature {

    @Reducer(state: .equatable)
    enum Destination {
        case alert(AlertState<AnimalHomeFeature.Action.Alert>)
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
}

extension AlertState where Action == AnimalHomeFeature.Action.Alert {
    static func showAD(animalContent: [AnimalContent]) -> Self {
        Self {
            TextState("Watch Ad to continue and Cancel")
        } actions: {
            ButtonState(action: .showAD(animalContent)) {
                TextState("Show Ad")
            }

            ButtonState(role: .cancel) {
                TextState("Cancel")
            }
        }
    }

    static var comingSoon: Self {
        Self {
            TextState("Coming Soon")
        }
    }
}
