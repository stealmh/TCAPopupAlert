//
//  PopupAlertState.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI
import ComposableArchitecture

public struct PopupAlertState<Action: Equatable>: Equatable {
    public var message: TextState?
    public var title: TextState?
    public var leadingButton: Button?
    public var trailingButton: Button?
    public var footerButton: Button?
    
    public init(
        title: TextState? = nil,
        message: TextState? = nil,
        footerButton: Button? = nil
    ) {
        self.footerButton = footerButton
        self.message = message
        self.title = title
    }
    
    public init(
        title: TextState? = nil,
        message: TextState? = nil,
        leadingButton: Button? = nil,
        trailingButton: Button? = nil,
        footerButton: Button? = nil
    ) {
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
        self.footerButton = footerButton
        self.message = message
        self.title = title
    }
    
    public struct Button: Equatable {
        public let action: MenuAction?
        public let title: TextState?
        
        public init(
            title: TextState? = nil,
            action: MenuAction? = nil
        ) {
            self.action = action
            self.title = title
        }
    }
    
    public struct MenuAction: Equatable {
        public let action: Action
        public let animation: Animation
        
        public enum Animation: Equatable {
            case inherited
            case explicit(SwiftUI.Animation?)
        }
        
        public init(
            action: Action,
            animation: SwiftUI.Animation?
        ) {
            self.action = action
            self.animation = .explicit(animation)
        }
        
        public init(action: Action) {
            self.action = action
            self.animation = .inherited
        }
    }
}
/// for ifLet
extension PopupAlertState: _EphemeralState {
    public static var actionType: Any.Type { Action.self }
}

