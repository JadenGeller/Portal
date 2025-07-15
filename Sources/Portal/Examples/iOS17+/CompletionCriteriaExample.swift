#if DEBUG
import SwiftUI

/// Completion criteria example for iOS 17+
@available(iOS 17.0, *)
public struct CompletionCriteriaExample: View {
    @State private var showDetail = false
    @State private var completionMessage = ""
    @State private var transitionCount = 0
    
    public init() {}
    
    public var body: some View {
        PortalContainer {
            NavigationView {
                ScrollView {
                    VStack(spacing: 32) {
                        
                        Text("Precise control over portal animation completion")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 16) {
                            Text("Transitions completed: \(transitionCount)")
                                .font(.headline)
                                .foregroundColor(.purple)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        
                        AnimatedLayer(id: "completionDemo") {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple, Color.pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    VStack(spacing: 7) {
                                        Image(systemName: "checkmark.circle.fill")
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
                        .portalSource(id: "completionDemo")
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showDetail.toggle()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Completion Criteria")
                .navigationBarTitleDisplayMode(.inline)
                .scrollContentBackground(.hidden)
            }
            .sheet(isPresented: $showDetail) {
                DetailWithCompletionView(
                    showDetail: $showDetail,
                    completionMessage: $completionMessage,
                    transitionCount: $transitionCount
                )
            }
            .portalTransition(
                id: "completionDemo",
                config: .init(
                    animation: PortalAnimation(
                        portal_animationExample
                    )
                ),
                isActive: $showDetail,
                layerView: {
                    AnimatedLayer(id: "completionDemo") {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                VStack(spacing: 7) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    Text("Portal")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                            )
                    }
                },
                completion: { success in
                    // This closure runs when the portal transition completes
                    DispatchQueue.main.async {
                        transitionCount += 1
                        completionMessage = success
                        ? "Transition completed successfully!"
                        : "Transition was cancelled"
                        
                        // Clear the message after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            completionMessage = ""
                        }
                    }
                }
            )
        }
    }
}

@available(iOS 17.0, *)
private struct DetailWithCompletionView: View {
    @Binding var showDetail: Bool
    @Binding var completionMessage: String
    @Binding var transitionCount: Int
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 32) {
                    
                    AnimatedLayer(id: "completionDemo") {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                VStack(spacing: 7) {
                                    Image(systemName: "checkmark.circle.fill")
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
                    .portalDestination(id: "completionDemo")
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showDetail = false
                        }
                    }
                    
                    Text("Portal supports iOS 17+ completion criteria for precise control over when completion callbacks are triggered. Perfect for complex state management and transition sequencing.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Close") {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showDetail = false
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Completion Criteria Example")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    if #available(iOS 17, *){
        CompletionCriteriaExample()
    }
    else{
        Text("Please use iOS 17 or later")
    }
}


#endif
