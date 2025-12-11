import SwiftUI

struct ProductDetailView: View {
    let product: Product
    
    // This controls the "Overview" vs "Ingredients" switch
    @State private var selectedTab = 0
    
    // This allows us to open the URL
    @Environment(\.openURL) var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) { // Increased spacing for readability
                
                // 1. Large Product Image
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                // 2. High-Contrast Title
                Text(product.name)
                    .font(.system(size: 34, weight: .heavy, design: .rounded)) // Bigger & Bolder
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                
                // 3. Tab Picker (Fixes the "Swipe" confusion)
                Picker("Info Type", selection: $selectedTab) {
                    Text("Overview").tag(0)
                    Text("Ingredients").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // 4. Dynamic Content Area
                if selectedTab == 0 {
                    // Overview Tab
                    VStack(alignment: .leading, spacing: 20) {
                        InfoSection(title: "What is it?", text: product.whatIsIt)
                        InfoSection(title: "How it works", text: product.howItWorks)
                    }
                    .padding(.horizontal)
                    .transition(.opacity) // Smooth fade effect
                    
                } else {
                    // Ingredients Tab
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(product.ingredients)
                            .font(.body) // Standard readable size
                            .lineSpacing(6) // Easier to read lines
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .transition(.opacity)
                }
                
                // Spacer to ensure content isn't hidden behind the button
                Color.clear.frame(height: 100)
            }
            .padding(.top)
        }
        .safeAreaInset(edge: .bottom) {
            // 5. The REAL Purchase Button
            Button(action: {
                // This opens the link in Safari
                if let url = URL(string: product.purchaseLink) {
                    openURL(url)
                }
            }) {
                HStack {
                    Text("Get Yours Today")
                        .fontWeight(.bold)
                    Image(systemName: "arrow.up.right.square") // Shows it leaves the app
                }
                .font(.title3) // Larger button text
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18) // Taller button target
                .background(Color("AppGreen"))
                .cornerRadius(16)
                .shadow(color: Color("AppGreen").opacity(0.4), radius: 10, x: 0, y: 5)
                .padding()
            }
            .background(.ultraThinMaterial) // Blurry background behind button
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Helper View to make text consistent and readable
struct InfoSection: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(text)
                .font(.body)
                .foregroundColor(Color(.systemGray)) // Slightly softer than black for reading comfort
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color(.systemGray6)) // Light grey box for contrast
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: mockProduct)
    }
}
