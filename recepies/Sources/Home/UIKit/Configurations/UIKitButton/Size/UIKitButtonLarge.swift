import Foundation

struct UIKitButtonLarge: UIKitButtonSize {
    let height: CGFloat = 46
    let imageSize: CGSize = CGSize(width: 18, height: 18)
    let horizontalContentInset: CGFloat = 16
}

extension UIKitButtonSize where Self == UIKitButtonLarge {
    static var large: UIKitButtonSize { UIKitButtonLarge() }
}
