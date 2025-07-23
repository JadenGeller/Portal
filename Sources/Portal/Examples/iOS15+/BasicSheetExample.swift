#if DEBUG
import SwiftUI



/// Basic Portal sheet transition example for iOS 15+
/// Demonstrates a single element transitioning between main view and sheet
@available(iOS 15.0, *)
public struct BasicSheetExample: View {
    @State private var showDetail = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Text("Tap the card to see it expand in a sheet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // MARK: Source Card
                    VStack(spacing: 16) {
                        AnimatedLayer(id: "heroCard") {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.2, green: 0.6, blue: 0.9),
                                            Color(red: 0.1, green: 0.4, blue: 0.8)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .frame(width: 200, height: 120)
                        .portalSource(id: "heroCard")
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showDetail.toggle()
                            }
                        }
                        
                        
                        Text("Portal Card")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Basic Portal Sheet Example")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .sheet(isPresented: $showDetail) {
            DetailSheetView(showDetail: $showDetail)
        }
        .portalTransition(
            id: "heroCard",
            config: .init(animation: PortalAnimation(.spring(response: 0.4, dampingFraction: 0.8))),
            isActive: $showDetail,
            layerView: {
                AnimatedLayer(id: "heroCard") {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.2, green: 0.6, blue: 0.9),
                                    Color(red: 0.1, green: 0.4, blue: 0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
        )
        .portalContainer()
    }
}

@available(iOS 15.0, *)
private struct DetailSheetView: View {
    @Binding var showDetail: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Expanded View")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // MARK: Destination Card
                AnimatedLayer(id: "heroCard") {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.2, green: 0.6, blue: 0.9),
                                    Color(red: 0.1, green: 0.4, blue: 0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .frame(width: 280, height: 200)
                .portalDestination(id: "heroCard")
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showDetail.toggle()
                    }
                }
                
                VStack(spacing: 16) {
                    Text("This demonstrates Portal's core functionality")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Portal enables seamless transitions between views that wouldn't normally be possible with matchedGeometryEffect, such as transitioning elements across sheets, navigation pushes, and other view boundaries.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button("Close") {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showDetail = false
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    BasicSheetExample()
}

#endif
