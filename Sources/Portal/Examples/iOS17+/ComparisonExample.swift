#if DEBUG
import SwiftUI

/// Comparison example for iOS 18+
/// Shows Portal vs native iOS transition features
@available(iOS 18.0, *)
public struct ComparisonExample: View {
    @State private var showPortalSheet = false
    @State private var showNativeSheet = false
    @State private var showZoomSheet = false
    @Namespace private var namespace
    
    public init() {}
    
    public var body: some View {
        PortalContainer {
            NavigationView {
                ScrollView {
                    VStack(spacing: 32) {
                        
                        Text("See the difference between Portal and native iOS transitions")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 24) {
                            // MARK: Portal Example
                            VStack(spacing: 16) {
                                Text("Portal Transition")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                AnimatedLayer(id: "portalDemo") {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue, Color.cyan],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            VStack(spacing: 7) {
                                                Image(systemName: "arrow.up.right")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.white)
                                                Text("Portal")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                            }
                                        )
                                }
                                .frame(width: 160, height: 100)
                                .portalSource(id: "portalDemo")
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        showPortalSheet.toggle()
                                    }
                                }
                                
                                Text("Cross-layer transitions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // MARK: Native Example
                            VStack(spacing: 16) {
                                Text("Default Transition")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.orange, Color.red],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        VStack(spacing: 7) {
                                            Image(systemName: "arrow.up.right")
                                                .font(.system(size: 24))
                                                .foregroundColor(.white)
                                            Text("Default")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                        }
                                    )
                                    .frame(width: 160, height: 100)
                                    .matchedTransitionSource(id: "nativeDemo", in: namespace)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            showNativeSheet.toggle()
                                        }
                                    }
                                
                                Text("Same-layer transitions only")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // MARK: iOS 18 Zoom Example
                            VStack(spacing: 16) {
                                Text("iOS 18 Zoom")
                                    .font(.headline)
                                    .foregroundColor(.green)
                                
                                
                                VStack(spacing: 7) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text("Zoom")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                                    .frame(width: 160, height: 100)
                                    .matchedTransitionSource(id: "zoomDemo", in: namespace, configuration: { body in
                                        body
                                            .background(Color.green)
                                            .clipShape(.rect(cornerRadius: 16))
                                    })
                                
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            showZoomSheet.toggle()
                                        }
                                    }
                                
                                Text("iOS 18 zoom transition")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Portal vs Native Comparison")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
              
            }

            .sheet(isPresented: $showPortalSheet) {
                PortalComparisonSheet(showSheet: $showPortalSheet)
            }
            .sheet(isPresented: $showNativeSheet) {
                NativeComparisonSheet(showSheet: $showNativeSheet, namespace: namespace)
            }
            .sheet(isPresented: $showZoomSheet) {
                ZoomComparisonSheet(showSheet: $showZoomSheet, namespace: namespace)
                    .navigationTransition(.zoom(sourceID: "zoomDemo", in: namespace))
                
            }
            .portalTransition(
                id: "portalDemo",
                config: .init(animation: PortalAnimation(portal_animationExample)),
                isActive: $showPortalSheet,
                layerView: {
                    AnimatedLayer(id: "portalDemo") {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                VStack(spacing: 7) {
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text("Portal")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                            )
                    }
                }
            )
        }
    }
}

@available(iOS 17.0, *)
private struct ComparisonRow: View {
    let title: String
    let portalSupport: Bool
    let nativeSupport: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                Image(systemName: portalSupport ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(portalSupport ? .green : .red)
                    .font(.callout)
                
                Image(systemName: nativeSupport ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(nativeSupport ? .green : .red)
                    .font(.callout)
            }
        }
    }
}

@available(iOS 17.0, *)
private struct PortalComparisonSheet: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Portal Sheet Example")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // MARK: Portal Destination
                AnimatedLayer(id: "portalDemo") {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            VStack(spacing: 7) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                Text("Portal")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                        )
                }
                .frame(width: 280, height: 200)
                .portalDestination(id: "portalDemo")
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showSheet = false
                    }
                }
                
                
                Text("This element seamlessly transitioned from the main view to this sheet using Portal. This type of cross-layer transition is not possible with native matchedGeometryEffect.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Close") {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showSheet = false
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

@available(iOS 18.0, *)
private struct NativeComparisonSheet: View {
    @Binding var showSheet: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Native Sheet Example")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // MARK: Native - No transition possible
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        VStack(spacing: 7) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("No Transition")
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    )
                    .frame(width: 280, height: 200)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showSheet = false
                        }
                    }
                
                Text("This element appeared without any transition because native matchedGeometryEffect cannot work across sheet boundaries. The original element and this one exist in different view hierarchies.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Close") {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showSheet = false
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

@available(iOS 18.0, *)
private struct ZoomComparisonSheet: View {
    @Binding var showSheet: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("iOS 18 Zoom Example")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // MARK: iOS 18 Zoom - Works with matchedGeometryEffect
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.green, Color.mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        VStack(spacing: 7) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("Zoom Works!")
                                .font(.title2)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    )
                    .frame(width: 280, height: 200)
                    .matchedTransitionSource(id: "zoomDemo", in: namespace)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showSheet = false
                        }
                    }
                
                Text("iOS 18's zoom transition presents the sheet with a zoom animation that originates from the tapped element. It's a presentation style, not an element transition - the sheet zooms from the source element's position.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Close") {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showSheet = false
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
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
    if #available(iOS 18, *){
        ComparisonExample()
    }
    else{
        Text("Please use iOS 18 or later")
    }
}

#endif 
