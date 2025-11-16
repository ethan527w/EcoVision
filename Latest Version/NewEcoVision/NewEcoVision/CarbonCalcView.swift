//
//  CarbonCalcView.swift
//  NewEcoVision
//
//  Created by Ethan Wu on 11/9/25.
//

import SwiftUI

// A struct to hold each chat message
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool // true if user, false if "AI"
}

struct CarbonCalcView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hi! How can I help you calculate your carbon footprint today?", isUser: false)
    ]
    @State private var currentMessage = ""

    var body: some View {
        VStack {
            // 1. Chat History
            ScrollView {
                VStack {
                    ForEach(messages) { msg in
                        ChatBubble(message: msg)
                    }
                }
            }
            
            // 2. Input Area
            HStack {
                TextField("Enter your activity...", text: $currentMessage)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color("AppGreen")) // Using your green color
                }
            }
            .padding()
        }
        .navigationTitle("Carbon Calculator")
    }
    
    func sendMessage() {
        guard !currentMessage.isEmpty else { return }
        
        // 1. Add the user's message
        let userMessage = ChatMessage(text: currentMessage, isUser: true)
        messages.append(userMessage)
        
        // 2. Clear the input field
        currentMessage = ""
        
        // 3. Add the placeholder AI response
        let aiResponse = ChatMessage(text: "[WILL BE AI IN THE FUTURE VERSION]", isUser: false)
        
        // Add a slight delay to make it feel like a response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            messages.append(aiResponse)
        }
    }
}

// Helper View: A chat bubble
struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer() // Push user messages to the right
                Text(message.text)
                    .padding(12)
                    .background(Color("AppBlue")) // Your custom blue
                    .foregroundColor(.white)
                    .cornerRadius(16)
            } else {
                Text(message.text)
                    .padding(12)
                    .background(Color(.systemGray5))
                    .foregroundColor(.black)
                    .cornerRadius(16)
                Spacer() // Push AI messages to the left
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        CarbonCalcView()
    }
}
