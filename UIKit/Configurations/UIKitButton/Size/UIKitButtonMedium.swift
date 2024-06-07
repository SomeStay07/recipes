import Foundation

struct UIKitButtonMedium: UIKitButtonSize {
    let height: CGFloat = 32
    let imageSize: CGSize = CGSize(width: 18, height: 18)
    let horizontalContentInset: CGFloat = 12
}

extension UIKitButtonSize where Self == UIKitButtonMedium {
    static var medium: UIKitButtonSize { UIKitButtonMedium() }
}
