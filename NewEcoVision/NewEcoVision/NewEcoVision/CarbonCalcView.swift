//
//  CarbonCalcView.swift
//  NewEcoVision
//
//  Created by Ethan Wu on 11/9/25.
//
import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct CarbonCalcView: View {
    // We start with a friendly greeting
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hello! I'm your Eco-Assistant. Tell me about your day (e.g., 'I drove 10km' or 'I ate a steak') and I'll estimate your carbon footprint.", isUser: false)
    ]
    @State private var currentMessage = ""
    @State private var isTyping = false // New state to show "Thinking..."
    
    // Focus state to dismiss keyboard easily
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            // 1. Chat Area
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id) // Important for auto-scroll
                        }
                        
                        // The "Thinking" indicator
                        if isTyping {
                            HStack {
                                Text("EcoBot is typing...")
                                    .font(.caption)
                                    .italic()
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                Spacer()
                            }
                        }
                    }
                    .padding(.top)
                }
                // Auto-scroll to bottom when a new message appears
                .onChange(of: messages) { _ in
                    if let lastMsg = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMsg.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // 2. Input Area
            HStack {
                TextField("Type your activity here...", text: $currentMessage)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($isFocused)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(currentMessage.isEmpty ? .gray : Color("AppGreen"))
                        .rotationEffect(.degrees(45)) // Tilts the plane slightly
                }
                .disabled(currentMessage.isEmpty || isTyping)
            }
            .padding()
            .background(Color(.systemBackground)) // Covers content behind it
        }
        .navigationTitle("Carbon Calculator")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func sendMessage() {
        let userText = currentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !userText.isEmpty else { return }
        
        // 1. Add User Message
        let userMsg = ChatMessage(text: userText, isUser: true)
        messages.append(userMsg)
        currentMessage = ""
        isFocused = false // Hide keyboard
        
        // 2. Simulate AI Thinking
        isTyping = true
        
        // Randomize delay between 1 and 2 seconds to feel natural
        let randomDelay = Double.random(in: 1.0...2.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            // 3. Generate "Smart" Response
            let responseText = generateSmartResponse(for: userText)
            let aiMsg = ChatMessage(text: responseText, isUser: false)
            
            messages.append(aiMsg)
            isTyping = false
        }
    }
    
    // This function acts as our "Brain" until we connect real AI
    func generateSmartResponse(for input: String) -> String {
        let text = input.lowercased()
        
        if text.contains("car") || text.contains("drive") || text.contains("drove") {
            return "Driving relies on fossil fuels. For an average car, that's about 0.2kg of CO2 per mile. Have you considered public transport or biking for short trips?"
        } else if text.contains("meat") || text.contains("beef") || text.contains("steak") {
            return "Red meat has a high carbon footprint. One serving of beef can equal roughly 15kg of CO2! Replacing it with chicken or plant-based options reduces this significantly."
        } else if text.contains("flight") || text.contains("plane") || text.contains("fly") {
            return "Air travel is carbon-intensive. A short-haul flight can emit 150kg+ of CO2 per passenger. Consider offsetting this trip using our Eco Buy page!"
        } else if text.contains("plastic") || text.contains("bottle") {
            return "Plastic production generates CO2 and waste. Using a reusable bottle saves about 0.08kg of CO2 per refill compared to buying new plastic ones."
        } else if text.contains("hello") || text.contains("hi") {
            return "Hi there! I'm ready to help. Try telling me something like 'I flew to London' or 'I ate a burger'."
        } else {
            // Fallback response for unknown inputs
            return "That's an interesting activity. To calculate the exact footprint, could you provide more details, like the distance traveled or weight of the item?"
        }
    }
}

// Updated Bubble Design
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom) {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color("AppGreen")) // User is Green now
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .cornerRadius(2, corners: .bottomRight) // Little tail effect
            } else {
                Image(systemName: "leaf.circle.fill") // AI Avatar Icon
                    .font(.largeTitle)
                    .foregroundColor(Color("AppGreen"))
                
                Text(message.text)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.black)
                    .cornerRadius(16)
                    .cornerRadius(2, corners: .bottomLeft) // Little tail effect
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// Helper for the custom rounded corners (tail effect)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        CarbonCalcView()
    }
}
