import SwiftUI

/// Example demonstrating corner radius interpolation
@available(iOS 17.0, *)
public struct ClipShapeExample: View {
    @State private var showRoundedDemo = false
    @State private var showSquareDemo = false
    
    public init() {}
    
    public var body: some View {
        PortalContainer {
            NavigationView {
                VStack(spacing: 40) {
                    Text("Corner Radius Interpolation")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Watch how corner radius smoothly animates during portal transitions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 30) {
                        // Different corner radius demo
                        VStack(spacing: 16) {
                            Text("Sharp to Rounded")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue.gradient)
                                .frame(width: 120, height: 80)
                                .portalSource(id: "roundedDemo")
                                .onTapGesture {
                                    showRoundedDemo.toggle()
                                }
                            
                            Text("4pt → 32pt corners")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Square to rounded demo
                        VStack(spacing: 16) {
                            Text("Square to Pill")
                                .font(.headline)
                                .foregroundColor(.orange)
                            
                            Rectangle()
                                .fill(Color.orange.gradient)
                                .frame(width: 120, height: 80)
                                .portalSource(id: "squareDemo")
                                .onTapGesture {
                                    showSquareDemo.toggle()
                                }
                            
                            Text("0pt → 16pt corners")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Corner Interpolation")
            }
            .sheet(isPresented: $showRoundedDemo) {
                RoundedDemoSheet(showSheet: $showRoundedDemo)
            }
            .sheet(isPresented: $showSquareDemo) {
                SquareDemoSheet(showSheet: $showSquareDemo)
            }
            .portalTransition(
                id: "roundedDemo",
                config: .init(
                    animation: PortalAnimation(.spring(duration: 0.6)),
                    corners: PortalCorners(source: 4, destination: 32)
                ),
                isActive: $showRoundedDemo,
                layerView: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue.gradient)
                }
            )
            .portalTransition(
                id: "squareDemo", 
                config: .init(
                    animation: PortalAnimation(.spring(duration: 0.8)),
                    corners: PortalCorners(source: 0, destination: 150)
                ),
                isActive: $showSquareDemo,
                layerView: {
                    Rectangle()
                        .fill(Color.orange.gradient)
                }
            )
        }
    }
}

@available(iOS 17.0, *)
private struct RoundedDemoSheet: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Sharp to Rounded")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.blue.gradient)
                .frame(width: 200, height: 150)
                .portalDestination(id: "roundedDemo")
                .onTapGesture {
                    showSheet = false
                }
            
            Text("The corner radius smoothly interpolated from 4pt to 32pt during the transition. This creates a seamless visual connection between different corner styles.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Close") {
                showSheet = false
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}

@available(iOS 17.0, *)
private struct SquareDemoSheet: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Square to Pill")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            RoundedRectangle(cornerRadius: 150)
                .fill(Color.orange.gradient)
                .frame(width: 200, height: 150)
                .portalDestination(id: "squareDemo")
                .onTapGesture {
                    showSheet = false
                }
            
            Text("Watch how a sharp rectangle smoothly transforms into a rounded one. The corner radius animated from 0pt to 16pt during the portal transition.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Close") {
                showSheet = false
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        ClipShapeExample()
    } else {
        Text("iOS 17+ required")
    }
} 
