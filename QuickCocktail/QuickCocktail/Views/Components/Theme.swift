import SwiftUI

struct AppTheme {
    static let primaryGradient = LinearGradient(
        colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.1, green: 0.1, blue: 0.2),
            Color(red: 0.15, green: 0.1, blue: 0.25)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    
    struct Colors {
        static let amber = Color(red: 0.831, green: 0.584, blue: 0.216)
        static let gold = Color(red: 1.0, green: 0.843, blue: 0.0)
        static let darkPurple = Color(red: 0.2, green: 0.1, blue: 0.3)
        static let barBlack = Color(red: 0.1, green: 0.1, blue: 0.15)
        static let cocktailOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
        static let mintGreen = Color(red: 0.6, green: 0.9, blue: 0.7)
        static let cherryRed = Color(red: 0.8, green: 0.2, blue: 0.3)
    }
    
    struct Spacing {
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let rounded: CGFloat = 999
    }
    
    struct Shadow {
        static let small = (color: Color.black.opacity(0.1), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let medium = (color: Color.black.opacity(0.2), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        static let large = (color: Color.black.opacity(0.3), radius: CGFloat(12), x: CGFloat(0), y: CGFloat(6))
    }
}

extension Color {
    static let appAccent = AppTheme.Colors.amber
    static let appBackground = AppTheme.Colors.barBlack
}

struct GlassBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
            .shadow(
                color: AppTheme.Shadow.medium.color,
                radius: AppTheme.Shadow.medium.radius,
                x: AppTheme.Shadow.medium.x,
                y: AppTheme.Shadow.medium.y
            )
    }
}

extension View {
    func glassBackground() -> some View {
        modifier(GlassBackground())
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
            .shadow(
                color: AppTheme.Shadow.medium.color,
                radius: AppTheme.Shadow.medium.radius,
                x: AppTheme.Shadow.medium.x,
                y: AppTheme.Shadow.medium.y
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack(spacing: 20) {
            Text("Glass Background")
                .foregroundStyle(.white)
                .padding()
                .glassBackground()
            
            Text("Card Style")
                .foregroundStyle(.white)
                .padding()
                .frame(width: 200)
                .cardStyle()
            
            HStack(spacing: 10) {
                Circle().fill(AppTheme.Colors.amber).frame(width: 30)
                Circle().fill(AppTheme.Colors.gold).frame(width: 30)
                Circle().fill(AppTheme.Colors.cocktailOrange).frame(width: 30)
                Circle().fill(AppTheme.Colors.mintGreen).frame(width: 30)
                Circle().fill(AppTheme.Colors.cherryRed).frame(width: 30)
            }
        }
    }
}
