import SwiftUI

struct MainPageView: View {
    // @State variables update the UI when their value changes
    @State private var searchText = ""

    var body: some View {
        // NavigationStack allows us to "push" to a new screen (the detail page)
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Welcome Header
                    Text("Welcome to EcoVision")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    // 2. Search Bar (a simple version)
                    TextField("🔍 Search", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    // 3. Most Desirable Section
                    Text("Most Desirable")
                        .font(.headline)
                        .padding(.horizontal)

                    // 4. Product Card
                    // This NavigationLink makes the card tappable
                    NavigationLink(destination: ProductDetailView(product: mockProduct)) {
                        ProductCardView(product: mockProduct)
                    }
                    
                    // 5. Other Partners Section
                    Text("More brands joining soon...")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // You can add more NavigationLinks or a List here later

                    Spacer() // Pushes all content to the top
                }
                .padding(.top)
            }
            .navigationTitle("Eco Buy") // This title is for the navigation system
            .navigationBarHidden(true) // We hide it to match your design
        }
    }
}

// This is a helper view just for the card UI
struct ProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading) {
            // !! THIS IS WHERE YOUR UPLOADED IMAGE IS USED !!
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                
            Text(product.name)
                .font(.headline)
                .padding(.horizontal)
            
            Text(product.shortDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding([.horizontal, .bottom])
        }
        .background(Color.white) // Use Color(.systemBackground) for dark mode
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .tint(.black) // Ensures the text inside the link is black
    } 
}

#Preview {
    MainPageView()
}
