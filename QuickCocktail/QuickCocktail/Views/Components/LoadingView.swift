import SwiftUI

struct LoadingView: View {
    let message: String
    
    init(_ message: String = "Yükleniyor...") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(30)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct LoadingOverlay: View {
    let isLoading: Bool
    let message: String
    
    init(isLoading: Bool, message: String = "Yükleniyor...") {
        self.isLoading = isLoading
        self.message = message
    }
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                LoadingView(message)
            }
            .transition(.opacity)
        }
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.3),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

struct SkeletonCard: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.white.opacity(0.1))
                .frame(height: 140)
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 16)
                
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 80, height: 12)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shimmer()
    }
}

struct SkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 14)
                
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 100, height: 10)
            }
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shimmer()
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack(spacing: 20) {
            LoadingView()
            
            SkeletonCard()
                .frame(width: 160)
            
            SkeletonRow()
        }
        .padding()
    }
}
