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
        var animalDetail: AnimalDetailFeature.State?
    }

    @CasePathable
    enum Action {
        case animalDetail(AnimalDetailFeature.Action)
        case input(Input)
        case delegate(Delegate)
        case homeDidAppear
        case refreshDidEnd
        case didTapToPaidContent(String, [AnimalContent])
        case didTapToComingSoonContent
        case animalResponse(Result<IdentifiedArrayOf<Animal>, Error>)
        case destination(PresentationAction<Destination.Action>)
        case startAd
        case finishAd(String, [AnimalContent])
        case cellDidTap(String, [AnimalContent])

        enum Input {
            case fetchAnimals
        }

        enum Delegate: Equatable {
            case onCellDidTap(AnimalDetailFeature.State)
        }

        enum Alert: Equatable {
            case showAD(String, [AnimalContent])
        }
    }

    @Reducer(state: .equatable)
    enum Destination {
        case alert(AlertState<AnimalHomeFeature.Action.Alert>)
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
            case .homeDidAppear, .refreshDidEnd, .input(.fetchAnimals):
                return fetchAnimals()
            case .animalResponse(.success(let animals)):
                state.viewState = animals.isEmpty ? .empty : .fetched(animals)

                return .none

            case .animalResponse(.failure(let error)):
                state.viewState = .error(error.localizedDescription)

                return .none

            case let .didTapToPaidContent(category, content):
                state.destination = .alert(.showAD(category: category, animalContent: content))
                return .none

            case .didTapToComingSoonContent:
                state.destination = .alert(.comingSoon)
                return .none

            case let .destination(.presented(.alert(.showAD(category, content)))):
                return .run { send in
                    await send(.startAd)
                    try? await environment.clock.sleep(for: .seconds(2))
                    await send(.finishAd(category, content))
                }
            case .startAd:
                state.isAdShowing = true

                return .none

            case let .finishAd(category, content):
                state.isAdShowing = false
                return createDetailFeature(category: category, content: content, state: &state)

            case .destination:
                return .none

            case .delegate:
                return .none

            case .animalDetail(.output(.onBackDidTap)):
                return fetchAnimals()

            case .animalDetail:
                return .none

            case let .cellDidTap(category, content):
                return createDetailFeature(category: category, content: content, state: &state)
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func createDetailFeature(category: String, content: [AnimalContent], state: inout State) -> Effect<Action> {
        let detailState = AnimalDetailFeature.State(category: category, content: .init(uniqueElements: content))
        state.animalDetail = detailState

        return .send(.delegate(.onCellDidTap(detailState)))
    }

    private func fetchAnimals() -> Effect<Action> {
        .run { send in
            try await send(.animalResponse(.success(environment.animalCachedService.fetchAnimals())))
        } catch: { error, send in
            await send(.animalResponse(.failure(error)))
        }
    }
}

extension AlertState where Action == AnimalHomeFeature.Action.Alert {
    static func showAD(category: String, animalContent: [AnimalContent]) -> Self {
        Self {
            TextState("Watch Ad to continue and Cancel")
        } actions: {
            ButtonState(action: .showAD(category, animalContent)) {
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
