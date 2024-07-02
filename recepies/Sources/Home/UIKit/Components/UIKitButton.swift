import SwiftUI

// MARK: - UIKitButtonSize

protocol UIKitButtonSize {
    var height: CGFloat { get }
    var imageSize: CGSize { get }
    var horizontalContentInset: CGFloat { get }
}

// MARK: - UIKitButtonAppearance

protocol UIKitButtonAppearance {
    var font: Font { get }
    var weight: Font.Weight { get }
    var foregroundColor: Color { get }
    var backgroundColor: Color { get }
}

// MARK: - UIKitButtonType

protocol UIKitButtonType {
    var `default`: UIKitButtonAppearance { get }
    var enabled: UIKitButtonAppearance { get }
    var pressed: UIKitButtonAppearance { get }
    var disabled: UIKitButtonAppearance { get }
}

// MARK: - UIKitButtonImage

struct UIKitButtonImage {
    let imageName: String // FIXME: Replace string with component
    let alignment: Alignment
    
    enum Alignment {
        case leading
        case trailing
    }
}

enum UIKitButtonState {
    case `default`
    case enabled
    case pressed
    case disabled
}

// MARK: - UIKitButton

struct UIKitButton: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private let title: String
    private let isExpanded: Bool
    private let image: UIKitButtonImage?
    private let size: UIKitButtonSize
    private let type: UIKitButtonType
    private let state: UIKitButtonState
    private let action: () -> Void
    
    var body: some View {
        Button(
            action: action,
            label: { content }
        )
        .disabled(state == .disabled)
        .buttonStyle(
            UIKitButtonStyle(
                isExpanded: isExpanded,
                appearance: stateConfiguration,
                type: type,
                size: size
            )
        )
    }
    
    // MARK: - Init
    
    init(
        title: String,
        isExpanded: Bool = false,
        image: UIKitButtonImage? = nil,
        size: UIKitButtonSize = .medium,
        type: UIKitButtonType = .primary,
        state: UIKitButtonState = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isExpanded = isExpanded
        self.image = image
        self.type = type
        self.size = size
        self.state = state
        self.action = action
    }
    
}

// MARK: - Content

private extension UIKitButton {
    
    var content: some View {
        HStack(spacing: 8) {
            if image?.alignment == .leading {
                imageContent
            }
            
            text
            
            if image?.alignment == .trailing {
                imageContent
            }
        }
        .padding(size.horizontalContentInset)
    }
    
}

// MARK: - State configuration

private extension UIKitButton {
    
    var stateConfiguration: UIKitButtonAppearance {
        switch state {
        case .default: type.default
        case .enabled: type.enabled
        case .pressed: type.pressed
        case .disabled: type.disabled
        }
    }
    
}

// MARK: - Text

private extension UIKitButton {
    
    var text: some View {
        Text(title).font(stateConfiguration.font.customWeight(stateConfiguration.weight))
    }
    
}

// MARK: - Image

private extension UIKitButton {
    
    @ViewBuilder
    var imageContent: some View {
        if let image {
            Image(systemName: image.imageName)
            .frame(
                width: size.imageSize.width,
                height: size.imageSize.height
            )
        }
    }
    
}

// MARK: - Button style

struct UIKitButtonStyle: ButtonStyle {
    private let isExpanded: Bool
    private let appearance: UIKitButtonAppearance
    private let type: UIKitButtonType
    private let size: UIKitButtonSize
    
    // MARK: - Init
    
    init(
        isExpanded: Bool,
        appearance: UIKitButtonAppearance,
        type: UIKitButtonType,
        size: UIKitButtonSize
    ) {
        self.isExpanded = isExpanded
        self.appearance = appearance
        self.type = type
        self.size = size
    }
    
    // MARK: Body
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .if(isExpanded) { label in
                label.frame(maxWidth: .infinity)
            }
            .frame(height: size.height)
            .foregroundColor(
                configuration.isPressed
                ? type.pressed.foregroundColor
                : appearance.foregroundColor
            )
            .background(
                configuration.isPressed
                ? type.pressed.backgroundColor
                : appearance.backgroundColor
            )
            .cornerRadius(6)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        UIKitButton(
            title: "Конфиг номер 1",
            size: .large,
            type: .primary,
            state: .disabled,
            action: {
                print("Hello config 1")
            }
        )
        .padding()
        
        UIKitButton(
            title: "Кнопка #2",
            isExpanded: true,
            image: UIKitButtonImage(
                imageName: "star.fill",
                alignment: .leading
            ), 
            size: .medium,
            action: {}
        )
        .padding()
        
        UIKitButton(
            title: "Кнопка #3",
            image: UIKitButtonImage(
                imageName: "star.fill",
                alignment: .trailing
            ),
            size: .small,
            action: {}
        )
        .padding()
    }
}
