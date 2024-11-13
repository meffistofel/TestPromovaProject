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
        var toast: Toast?
    }

    enum Action: ViewAction {
        @CasePathable
        enum Local {
            case fetchAnimalsFromAPIFail
            case animalDatabaseResponse(Result<IdentifiedArrayOf<Animal>, Error>)
            case animalAPIResponse(Result<IdentifiedArrayOf<Animal>, Error>)
            case destination(PresentationAction<Destination.Action>)
            case startAd
            case finishAd(String, [AnimalContent])
        }

        @CasePathable
        enum View {
            case changeToastState(Toast?)
            case homeDidAppear
            case retryDidTap
            case refreshDidEnd
            case didTapToPaidContent(String, [AnimalContent])
            case didTapToComingSoonContent
            case cellDidTap(String, [AnimalContent])
        }

        enum Input {
            case fetchAnimals
        }

        enum Output: Equatable {
            case onCellDidTap(AnimalDetailFeature.State)
        }

        enum Alert: Equatable {
            case showAD(String, [AnimalContent])
        }

        case input(Input)
        case output(Output)
        case view(View)
        case local(Local)
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
#warning("TODO: it was possible to put it on onAppear, but it is less controlled, so the final approach depended on the specific need")
            case let .view(action):
                return handleView(action: action, state: &state)
            case let .input(action):
                return handleInput(action: action, state: &state)
            case let .local(action):
                return handleLocal(action: action, state: &state)
            case .output:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.local.destination)
    }
}

// MARK: Handle Events
private extension AnimalHomeFeature {
    func handleView(action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .retryDidTap:
            state.viewState = .loading

            return fetchAnimalsFromAPI(delay: 1)
        case .homeDidAppear:
            state.viewState = .loading

            return fetchAnimalsFromAPI()
        case .refreshDidEnd:
            return fetchAnimalsFromAPI()
        case let .didTapToPaidContent(category, content):
            state.destination = .alert(.showAD(category: category, animalContent: content))

            return .none
        case .didTapToComingSoonContent:
            state.destination = .alert(.comingSoon)

            return .none

        case let .changeToastState(toast):
            state.toast = toast

            return .none
        case let .cellDidTap(category, content):
            return createDetailFeature(category: category, content: content, state: &state)
        }
    }

    func handleInput(action: Action.Input, state: inout State) -> Effect<Action> {
        switch action {
        case .fetchAnimals:
            return fetchAnimalsFromAPI()
        }
    }

    func handleLocal(action: Action.Local, state: inout State) -> Effect<Action> {
        switch action {
        case let .animalAPIResponse(.success(items)):
            state.viewState = items.isEmpty ? .empty : .fetched(items)

            return .none

        case let .animalAPIResponse(.failure(error)):
            state.toast = .init(style: .error, message: error.localizedDescription)

            return .run { send in
                await send(.local(.fetchAnimalsFromAPIFail))
            }

        case let .animalDatabaseResponse(.success(items)):
            state.viewState = items.isEmpty ? .empty : .fetched(items)

            return .none

        case let .animalDatabaseResponse(.failure(error)):
            state.viewState = .error(error.localizedDescription)

            return .none

        case .fetchAnimalsFromAPIFail:
            return fetchAnimalsFromDatabase()

        case let .destination(.presented(.alert(.showAD(category, content)))):
            return .run { send in
                await send(.local(.startAd))
                try? await environment.clock.sleep(for: .seconds(2))
                await send(.local(.finishAd(category, content)))
            }
            
        case .startAd:
            state.isAdShowing = true

            return .none

        case let .finishAd(category, content):
            state.isAdShowing = false
            return createDetailFeature(category: category, content: content, state: &state)

        case .destination:
            return .none
        }
    }
}

// MARK: Methods
private extension AnimalHomeFeature {
    func createDetailFeature(category: String, content: [AnimalContent], state: inout State) -> Effect<Action> {
        let detailState = AnimalDetailFeature.State(category: category, content: .init(uniqueElements: content))
        state.animalDetail = detailState

        return .send(.output(.onCellDidTap(detailState)))
    }

    func fetchAnimalsFromAPI(delay: Double = 0) -> Effect<Action> {
        .run { send in
#warning("TODO: Added delay for API call when retry without internet for better smooth UI")
            try await environment.clock.sleep(for: .seconds(delay))
            try await send(.local(.animalAPIResponse(.success(environment.animalCachedService.fetchAnimalFromAPI()))))
        } catch: { error, send in
            await send(.local(.animalAPIResponse(.failure(error))))
        }
    }

    func fetchAnimalsFromDatabase() -> Effect<Action> {
        .run { send in
            try await send(.local(.animalDatabaseResponse(.success(environment.animalCachedService.fetchAnimalFromDataBase()))))
        } catch: { error, send in
            await send(.local(.animalDatabaseResponse(.failure(error))))
        }
    }
}

extension AlertState where Action == AnimalHomeFeature.Action.Alert {
    static func showAD(category: String, animalContent: [AnimalContent]) -> Self {
        Self {
            TextState("Watch Ad to continue or Cancel")
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
