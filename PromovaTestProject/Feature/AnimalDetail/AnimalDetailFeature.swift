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
        let category: String
        let content: IdentifiedArrayOf<AnimalContent>
        var currentIndex: Int = 0

        var currentItem: AnimalContent { content[currentIndex] }
    }

    enum Action: ViewAction {

        @CasePathable
        enum View: Equatable {
            case backDidTap
            case didTapBackward
            case didTapForward
            case changeIndexWithSwipe(Int)
        }

        enum Local {
            case backDidTap
        }

        enum Output {
            case onBackDidTap
        }

        case output(Output)
        case view(View)
        case local(Local)
    }

    @Dependency(\.dismiss) private var dismiss

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .local(action):
                return handleLocal(action: action, state: &state)
                
            case let .view(action):
                return handleView(action: action, state: &state)

            case .output:
                return .none
            }
        }
    }
}

// MARK: Handle Actions
private extension AnimalDetailFeature {
    func handleLocal(action: Action.Local, state: inout State) -> Effect<Action> {
        switch action {
        case .backDidTap:
            return .run { send in
                await send(.output(.onBackDidTap))
                await dismiss()
            }
        }
    }

    func handleView(action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .backDidTap:
            return .run { send in
                await send(.local(.backDidTap))
            }
        case .didTapBackward:
            state.currentIndex -= 1

            return .none
        case .didTapForward:
            state.currentIndex += 1

            return .none
        case let .changeIndexWithSwipe(index):
            state.currentIndex = index

            return .none
        }
    }
}
