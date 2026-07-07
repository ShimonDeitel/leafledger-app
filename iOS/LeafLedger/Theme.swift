import SwiftUI

/// Leaf Ledger's unique visual identity - a palette and mood distinct from every
/// sibling app in this portfolio, tuned to the plant domain.
enum AppTheme {
    static let background = Color(red: 0.063, green: 0.082, blue: 0.067)
    static let card = Color(red: 0.090, green: 0.122, blue: 0.094)
    static let accent = Color(red: 0.357, green: 0.651, blue: 0.357)
    static let secondary = Color(red: 0.890, green: 0.698, blue: 0.235)
    static let primaryText = Color(red: 0.929, green: 0.953, blue: 0.925)
    static let mutedText = Color(red: 0.929, green: 0.953, blue: 0.925).opacity(0.6)

    static let titleFont: Font = .system(.title2, design: .serif).weight(.bold)
    static let headlineFont: Font = .system(.headline, design: .rounded)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .monospaced)

    static let cornerRadius: CGFloat = 16
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.card)
            .cornerRadius(AppTheme.cornerRadius)
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardBackground()) }
}
