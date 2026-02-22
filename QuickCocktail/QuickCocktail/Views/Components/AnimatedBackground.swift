import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    
    private let gradientColors: [Color] = [
        Color(red: 0.1, green: 0.1, blue: 0.2),
        Color(red: 0.2, green: 0.1, blue: 0.3),
        Color(red: 0.15, green: 0.15, blue: 0.25),
        Color(red: 0.1, green: 0.2, blue: 0.3)
    ]
    
    var body: some View {
        LinearGradient(
            colors: animateGradient ? gradientColors : gradientColors.reversed(),
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct GlassmorphicCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct FloatingBubble: View {
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0.3
    
    let size: CGFloat
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [.white.opacity(0.3), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .opacity(opacity)
            .offset(y: offset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    offset = -50
                    opacity = 0.6
                }
            }
    }
}

struct AnimatedBackgroundWithBubbles: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            GeometryReader { geometry in
                ForEach(0..<8) { index in
                    FloatingBubble(
                        size: CGFloat.random(in: 20...60),
                        delay: Double(index) * 0.3
                    )
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: geometry.size.height * 0.5...geometry.size.height)
                    )
                }
            }
        }
    }
}

#Preview {
    AnimatedBackgroundWithBubbles()
}
