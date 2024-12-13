//
//  HomeFeature.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action: ViewAction {
        case view(View)
        case destination(PresentationAction<Destination.Action>)
        
        enum View: BindableAction, Equatable {
            case binding(BindingAction<State>)
            case buttonTapped
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case let .view(action):
                return viewAction(action, state: &state)
                
            case let .destination(action):
                return destinationAction(action, state: &state)
            }
        }
        .ifLet(\.$destination, action: \.destination)
        ._printChanges()
    }
}
//MARK: - Action
extension HomeFeature {
    func viewAction(_ action: Action.View, state: inout State) -> Effect<Action> {
        switch action {
        case .binding:
            return .none
            
        case .buttonTapped:
            state.destination = .alert(
                .init(
                    title: TextState("첫번째 알림"),
                    message: TextState("두번째 알림을 확인하시겠습니까?"),
                    leadingButton: .init(
                        title: TextState("네"),
                        action: .init(action: .okButtonTapped)
                    ),
                    trailingButton: .init(
                        title: TextState("아니요"),
                        action: .init(action: .cancelButtonTapped)
                    )
                )
            )
            return .none
        }
    }
    
    func destinationAction(_ action: PresentationAction<HomeFeature.Destination.Action>, state: inout State) -> Effect<Action> {
        switch action {
        case .presented(.alert(.okButtonTapped)):
            state.destination = .remindAlert(
                .init(
                    message: TextState("두번째 알림입니다"),
                    footerButton: .init(
                        title: TextState("확인"),
                        action: .init(action: .remindOkButtonTapped)
                    )
                )
            )
            return .none
            
        case .presented(.alert(.cancelButtonTapped)):
            return .none
            
        case .presented(.alert(.remindOkButtonTapped)):
            return .none
            
        case .presented, .dismiss:
            return .none
        }
    }
}

extension HomeFeature {
    @Reducer(state: .equatable)
    enum Destination {
        @ReducerCaseEphemeral
        case alert(PopupAlertState<Alert>)
        @ReducerCaseEphemeral
        case remindAlert(PopupAlertState<Alert>)
    }
    
    enum Alert: Equatable {
        /// alert
        case okButtonTapped
        case cancelButtonTapped
        case popupChange
        /// remind Alert
        case remindOkButtonTapped
    }
}
