#if DEBUG
import SwiftUI

/// Multiple Portal transitions example for iOS 15+
/// Demonstrates handling multiple simultaneous portal transitions
@available(iOS 15.0, *)
public struct MultiplePortalsExample: View {
    @State private var showRedDetail = false
    @State private var showBlueDetail = false
    @State private var showGreenDetail = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
                ScrollView {
                    VStack(spacing: 32) {
                        Text("Multiple Portal Transitions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Tap any shape to see independent portal transitions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 24) {
                            // MARK: Red Portal
                            VStack(spacing: 12) {
                                AnimatedLayer(id: "redShape") {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.red, Color.orange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                .frame(width: 80, height: 80)
                                .portalSource(id: "redShape")
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        showRedDetail.toggle()
                                    }
                                }
                                .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Text("Red Portal")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            
                            // MARK: Blue Portal
                            VStack(spacing: 12) {
                                AnimatedLayer(id: "blueShape") {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue, Color.cyan],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                .frame(width: 100, height: 60)
                                .portalSource(id: "blueShape")
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        showBlueDetail.toggle()
                                    }
                                }
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Text("Blue Portal")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            
                            // MARK: Green Portal
                            VStack(spacing: 12) {
                                AnimatedLayer(id: "greenShape") {
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.green, Color.mint],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                .frame(width: 120, height: 40)
                                .portalSource(id: "greenShape")
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        showGreenDetail.toggle()
                                    }
                                }
                                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Text("Green Portal")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                        
                        Text("Try opening multiple sheets simultaneously to see how Portal handles concurrent transitions")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Multiple Portals")
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            }
            .sheet(isPresented: $showRedDetail) {
                DetailSheet(
                    id: "redShape",
                    title: "Red Circle",
                    description: "This red circle transitioned independently from the other shapes",
                    showDetail: $showRedDetail
                ) {
                    AnimatedLayer(id: "redShape") {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.red, Color.orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .frame(width: 200, height: 200)
                    .portalDestination(id: "redShape")
                }
            }
            .sheet(isPresented: $showBlueDetail) {
                DetailSheet(
                    id: "blueShape",
                    title: "Blue Rectangle",
                    description: "This blue rectangle has its own independent portal transition",
                    showDetail: $showBlueDetail
                ) {
                    AnimatedLayer(id: "blueShape") {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .frame(width: 250, height: 150)
                    .portalDestination(id: "blueShape")
                }
            }
            .sheet(isPresented: $showGreenDetail) {
                DetailSheet(
                    id: "greenShape",
                    title: "Green Capsule",
                    description: "This green capsule demonstrates yet another independent portal",
                    showDetail: $showGreenDetail
                ) {
                    AnimatedLayer(id: "greenShape") {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.mint],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .frame(width: 300, height: 100)
                    .portalDestination(id: "greenShape")
                }
            }
            .portalTransition(
                id: "redShape",
                config: .init(animation: PortalAnimation(.spring(response: 0.5, dampingFraction: 0.8))),
                isActive: $showRedDetail,
                layerView: {
                    AnimatedLayer(id: "redShape") {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.red, Color.orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .portalTransition(
                id: "blueShape",
                config: .init(animation: PortalAnimation(.spring(response: 0.5, dampingFraction: 0.8))),
                isActive: $showBlueDetail,
                layerView: {
                    AnimatedLayer(id: "blueShape") {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .portalTransition(
                id: "greenShape",
                config: .init(animation: PortalAnimation(.spring(response: 0.5, dampingFraction: 0.8))),
                isActive: $showGreenDetail,
                layerView: {
                    AnimatedLayer(id: "greenShape") {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.mint],
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
private struct DetailSheet<Content: View>: View {
    let id: String
    let title: String
    let description: String
    @Binding var showDetail: Bool
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                content()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            showDetail = false
                        }
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                VStack(spacing: 16) {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Portal allows multiple independent transitions to work simultaneously without interference.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button("Close") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
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
    MultiplePortalsExample()
}

#endif 
