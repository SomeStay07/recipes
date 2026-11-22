import SwiftUI

private struct CornerRadiusStyle: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(
                    width: radius,
                    height: radius
                )
            )
            
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content.clipShape(
            CornerRadiusShape(
                radius: radius,
                corners: corners
            )
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(
            content: self,
            modifier: CornerRadiusStyle(
                radius: radius,
                corners: corners
            )
        )
    }
}
