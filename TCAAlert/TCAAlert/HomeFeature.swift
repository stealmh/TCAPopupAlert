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
        @Presents var alert: PopupAlertState<Alert2>?
        @Presents var remindAlert: PopupAlertState<Alert2>? /// one Button
    }
    
    enum Alert2: Equatable {
        /// alert
        case okButtonTapped
        case cancelButtonTapped
        case popupChange
        /// remind Alert
        case remindOkButtonTapped
    }
    
    enum Action: ViewAction, Equatable {
        case view(View)
        case alert(PresentationAction<Alert>)
        
        enum View: BindableAction, Equatable {
            case binding(BindingAction<State>)
            case buttonTapped
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
    
    var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            case let .view(action):
                return viewAction(action, state: &state)
                
            case let .alert(action):
                return alertAction(action, state: &state)
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$remindAlert, action: \.alert)
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
            state.alert = .init(
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
            return .none
        }
    }
    
    func alertAction(_ action: PresentationAction<Action.Alert>, state: inout State) -> Effect<Action> {
        switch action {
        case .presented(.okButtonTapped):
            print("hello")
//            state.remindAlert = .init(
//                message: TextState("두번째 알림이에요."),
//                footerButton: .init(
//                    title: TextState("확인"),
//                    action: .init(action: .remindOkButtonTapped)
//                )
//            )
            //            state.alert = .init(
            //                message: TextState("두번째 알림이에요."),
            //                footerButton: .init(
            //                    title: TextState("확인"),
            //                    action: .init(action: .remindOkButtonTapped)
            //                )
            //            )
//            return .run { send in
//                await send(.alert(.presented(.popupChange)), animation: .spring)
//            }
            return .none
            
        case .presented(.popupChange):
            state.remindAlert = .init(
                message: TextState("두번째 알림이에요."),
                footerButton: .init(
                    title: TextState("확인"),
                    action: .init(action: .remindOkButtonTapped)
                )
            )
            
            return .none
            
        case .presented(.cancelButtonTapped):
            return .none
            
        case .presented(.remindOkButtonTapped):
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
        case alert(PopupAlertState<Alert2>)
        case remindAlert
    }
}
