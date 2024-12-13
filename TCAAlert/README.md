# TCA Alert

이 Repository는 Pointfree의 isowords를 참고해 만든 Custom alert을 구성하는 방법을 제공합니다.
https://github.com/pointfreeco/isowords

이를 토대로 편하게 가지고 놀 수 있는 데모 앱을 만들었습니다.
![Simulator Screen Recording - iPhone 15 Pro - 2024-12-13 at 17 53 24](https://github.com/user-attachments/assets/a9411a45-813e-4efc-a681-02405b04da0d)

## 사용법
TCA를 의존하지 않더라도 기본적으로 사용할 수 있습니다.

```swift
public struct PopupAlert {
    public var title: Text?
    public var message: Text?
    public var leadingButton: Button?
    public var trailingButton: Button?
    public var footerButton: Button?
    public var isBackgroundDismissable: Bool
}
```
`title`: Alert의 좌측 상단에 위치한 `Text`입니다.
`message`: Alert 중앙에 위치한 `Text`입니다.
`leadingButton`, `trailingButton`: 각각 Alert의 하단에 위치하며, 좌측과 우측을 담당하는 `Button`입니다.
`footerButton`: Alert의 하단에 위치하는 `Button`입니다.
`isBackgroundDismissable`: Alert 외부 영역을 터치해 Alert을 사라지게 할 수 있는지 여부를 제어하기 위한`Flag`입니다.

Alert은 일반적으로 하단 버튼이 1개 또는 2개로 구성됩니다.
생성자를 달리하여 `footerButton` 또는 `leadingButton`과 `trailingButton`을 구성할 수 있습니다. 
<br>

>예를들어 버튼을 2개로 설정하고 싶다면
```swift
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
```
다음과 같은 생성자를 사용할 수 있습니다.
그럼에도 버튼 값을 받을 수 있게 구성한 이유는 Alert에는 Button이 없는 형태 또한 존재하기 때문입니다.
<br>
>버튼을 1개로 설정하고 싶다면
```swift
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
```
`footerButton`만 있는 생성자를 사용하면 됩니다.
<br>
이후 View Extension을 통해 ViewModifier를 만들어준 후 사용하게 됩니다.
```swift
extension View {
    public func alert(item: Binding<PopupAlert?>) -> some View {
        self.modifier(PopupAlertModifier(item: item))
    }
}

private struct PopupAlertModifier: ViewModifier {
    @Binding var item: PopupAlert?
    
    func body(content: Content) -> some View {
        ...
    }
}

struct HomeView {
    @State private var alert: PopupAlert?
    var body: some View {
        VStack {
            Button("TAP") {
                withAnimation {
                    self.alert = PopupAlert(...)
                }
            }
        }
        .alert(item: self.$alert.animation())
    }
}
```
<br>
<br>

그렇다면 TCA에서 사용하기 위해선 어떤 과정이 필요할까요?
PopupAlertState를 만드는 것에서 부터 시작합니다.
```swift
public struct PopupAlertState<Action: Equatable>: Equatable {
    public var message: TextState?
    public var title: TextState?
    public var leadingButton: Button?
    public var trailingButton: Button?
    public var footerButton: Button?
    public var isBackgroundDismissable: Bool
}
```
PopupAlert과 동일합니다. 다만 TextState를 사용해 한번 더 래핑했다는 것에서 차이가 있습니다.
<br>
```swift
// PopupAlert Button
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

// PopupAlertState Button
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
```
Button도 한번 더 래핑해주었습니다.

PopupAlertState에서 PopupAlert으로 매핑해주는 과정 또한 필요합니다.
케이스에 따라 어떤 버튼이 들어올 지 구분 후 변환해줄 수 있습니다.
<br>
```swift
/// PopupAlertState.Button -> PopupAlert.Button
extension PopupAlertState.Button {
    fileprivate func converted(
        send: @escaping (Action) -> Void,
        animation: @escaping (Action, Animation?) -> Void
    ) -> PopupAlert.Button {
        .init(
            title: self.title.map { Text($0) },
            action: {
                if let action = self.action {
                    switch action.animation {
                    case .inherited:
                        send(action.action)
                    case let .explicit(ani):
                        animation(action.action, ani)
                    }
                }
            }
        )
    }
}


//ex) footerButton만 존재할 때
public func converted(
    send: @escaping (Action) -> Void,
    animation: @escaping (Action, Animation?) -> Void
) -> PopupAlert {
    .init(
        title: self.title.map { Text($0) },
        message: self.message.map { Text($0) },
        footerButton: self.footerButton.map { $0.converted(send: send, animation: animation) },
        isBackgroundDismissable: self.isBackgroundDismissable
    )
}
```
마지막으로 View Extension까지 매핑해준다면 끝이나게 됩니다.
직전 매핑했던 케이스에 따라 나눠줍니다.
<br>
```swift
extension View {
    public func alert<MenuAction: Equatable>(
        _ item: Binding<Store<PopupAlertState<MenuAction>, MenuAction>?>
    ) -> some View {
        /// Binding으로 받은 현재 값
        let store = item.wrappedValue
        /// `PopupAlertState<MenuAction>`의 인스턴스
        let state = store?.withState { $0 }
        return self.alert(
            item: Binding(
                get: {
                    /// case 1) footer만 있을 때
                    if let _ = state?.footerButton {
                        state?.converted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                    /// case 2) leadingButton, trailingButton이 있을 때
                    else if let _ = state?.leadingButton,
                            let _ = state?.trailingButton {
                        state?.twoButtonConverted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                    /// case 3) 아무 버튼도 없을 때
                    else {
                        state?.noButtonConverted(send: { store?.send($0) }, animation: { store?.send($0, animation: $1) })
                    }
                },
                set: { if $0 == nil { item.transaction($1).wrappedValue = nil } }
            )
        )
    }
}
```
<br>

Reducer에서 만들었던 PopupAlertState를 사용해보겠습니다.
저는 연달아 나타나는 Alert 케이스를 만들어봤습니다.
```swift
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
```
<br>
Destination이라는 Reducer를 내부에 만들어 준 후 케이스를 추가해줍니다.

```swift
struct State: Equatable {
    @Presents var destination: Destination.State?
}
```
<br>
그렇다면 State에는 다음과 같이 들어올 수 있을거에요.

```swift
enum Action: ViewAction {
    case view(View)
    case destination(PresentationAction<Destination.Action>)
        
    enum View: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case buttonTapped
    }
}
```
<br>
Action에는 마찬가지로 Destination의 Action을 받을 수 있습니다.

```swift
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
}
```
ifLet을 추가해 화면에 보여질 수 있게 설정합니다.

```swift
var body: some View {
   ...
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    .alert($store.scope(state: \.destination?.remindAlert, action: \.destination.remindAlert))
}
```
그렇다면 View에서는 다음과 같이 modifier를 설정해줄 수 있을 거에요.


이제 버튼을 눌렀을 때 PopupAlertState를 만들어주기만 하면 됩니다.
<br>
```swift
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
```

버튼들의 액션은 항상 화면이 닫힌 후 작동하게 됩니다.

이후 `okButtonTapped` 액션을 받아보겠습니다.
```swift
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
```
Destination이 열거형이기 때문에 자연스럽게 화면 전환이 이뤄질 수 있습니다.


## 실행결과

|<img src="https://github.com/user-attachments/assets/c1127815-ee9a-4b67-bc0e-d733bc1e8a27" width="300"></img>|<img src="https://github.com/user-attachments/assets/a9411a45-813e-4efc-a681-02405b04da0d" width="300"></img>|
|:-:|:-:|
|`TCA+PopupAlert`| `PopupAlert` |
