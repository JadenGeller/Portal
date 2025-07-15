#if DEBUG
import SwiftUI

/// Basic Portal navigation transition example for iOS 15+
/// Demonstrates element transitions during navigation pushes
@available(iOS 15.0, *)
public struct BasicNavigationExample: View {
    @State private var showDetail = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    
                    Text("Tap the image to navigate and see the portal transition")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // MARK: Source Image
                    VStack(spacing: 16) {
                        AnimatedLayer(id: "heroImage") {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.9, green: 0.3, blue: 0.4),
                                            Color(red: 0.7, green: 0.1, blue: 0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    Image(systemName: "photo.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white.opacity(0.8))
                                )
                        }
                        .frame(width: 150, height: 150)
                        .portalSource(id: "heroImage")
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                showDetail.toggle()
                            }
                        }
                        
                        Text("Portal Image")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Basic Portal Navigation")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .background(
                NavigationLink(destination: DetailNavigationView(), isActive: $showDetail) {
                    EmptyView()
                }
                    .opacity(0)
            )
        }
        .portalTransition(
            id: "heroImage",
            config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
            isActive: $showDetail,
            layerView: {
                AnimatedLayer(id: "heroImage") {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.9, green: 0.3, blue: 0.4),
                                    Color(red: 0.7, green: 0.1, blue: 0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    .overlay(
                        Image(systemName: "photo.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    )
                    
                }
            }
        )
        .portalContainer()
    }
}

@available(iOS 15.0, *)
private struct DetailNavigationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // MARK: Destination Image
                AnimatedLayer(id: "heroImage") {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.9, green: 0.3, blue: 0.4),
                                    Color(red: 0.7, green: 0.1, blue: 0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    .overlay(
                        Image(systemName: "photo.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                    )
                    
                }
                .frame(width: 300, height: 250)
                .portalDestination(id: "heroImage")
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    Text("Portal Navigation Example")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("This image transitioned seamlessly from the previous view using Portal. This works across navigation pushes, unlike traditional matchedGeometryEffect which only works within the same view hierarchy.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Notice how the image maintains its visual continuity even though it's now in a completely different navigation context.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Image Detail")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    BasicNavigationExample()
}

#endif
