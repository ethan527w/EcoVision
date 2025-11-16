//
//  ProductDetailView.swift
//  NewEcoVision
//
//  Created by Ethan Wu on 11/9/25.
//


import SwiftUI

struct ProductDetailView: View {
    // This view receives a Product to display
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // 1. Product Image
                // !! YOUR IMAGE IS USED AGAIN HERE !!
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                // 2. Product Title
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // 3. What is it?
                VStack(alignment: .leading) {
                    Text("What is it?")
                        .font(.headline)
                    Text(product.whatIsIt)
                        .font(.body)
                }
                .padding(.horizontal)
                
                // 4. How it works
                VStack(alignment: .leading) {
                    Text("How it works")
                        .font(.headline)
                    Text(product.howItWorks)
                        .font(.body)
                }
                .padding(.horizontal)
                
                Spacer() // Pushes button to the bottom
            }
        }
        // This button is "sticky" at the bottom
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                // Add purchase logic here later
                print("Purchase button tapped")
            }) {
                Text("Click here to purchase")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AppGreen")) // Using your custom color
                    .cornerRadius(16)
                    .padding()
            }
            .background(.white.opacity(0.8)) // Adds a slight blur effect
        }
        .navigationTitle(product.name) // Shows title in the top nav bar
        .navigationBarTitleDisplayMode(.inline) // Makes title small
    }
}

#Preview {
    // This preview wrapper lets you see the page in navigation context
    NavigationStack {
        ProductDetailView(product: mockProduct)
    }
}