//
//  PopupAlert.swift
//  TCAAlert
//
//  Created by 김민호 on 12/10/24.
//

import SwiftUI

/// Alert을 구성합니다.
/// - 이름은 기본적으로 프로젝트 이름를 따라가는 것이 좋습니다. ex) PokitAlert, WKAlert etc
/*
 ----------------------
 |        title       |
 |                    |
 |       message      |
 |                    |
 | (lb tb) or footer  |
 |                    |
 ----------------------
*/
public struct PopupAlert {
    public var title: Text?
    public var message: Text?
    public var leadingButton: Button?
    public var trailingButton: Button?
    public var footerButton: Button?
    public var isBackgroundDismissable: Bool
    
    /// - `button`이 `2개`일 때 사용하는 initalizer
    /// - footerButton => nil
    public init(
        title: Text? = nil,
        message: Text? = nil,
        leadingButton: Button? = nil,
        trailingButton: Button? = nil,
        isBackgroundDismissable: Bool = true
    ) {
        self.title = title
        self.message = message
        self.leadingButton = leadingButton
        self.trailingButton = trailingButton
        self.footerButton = nil
        self.isBackgroundDismissable = isBackgroundDismissable
    }
    /// - `button`이 `1개`일 때 사용하는 initalizer
    /// - leadingButton, trailing Button => nil
    public init(
        title: Text? = nil,
        message: Text? = nil,
        footerButton: Button? = nil,
        isBackgroundDismissable: Bool = true
    ) {
        self.title = title
        self.message = message
        self.leadingButton = nil
        self.trailingButton = nil
        self.footerButton = footerButton
        self.isBackgroundDismissable = isBackgroundDismissable
    }
    /// Button 구성
    public struct Button: Identifiable {
        public let id: UUID
        public let title: Text?
        public let action: () -> Void
        
        public init(
            title: Text?,
            action: @escaping () -> Void
        ) {
            self.id = UUID()
            self.title = title
            self.action = action
        }
    }
}

