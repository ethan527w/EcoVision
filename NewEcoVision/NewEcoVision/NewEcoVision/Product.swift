import Foundation

// This struct defines what a "Product" is in our app
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let shortDescription: String
    let whatIsIt: String
    let howItWorks: String
}

// We can create our "mock" data right here for testing
// This is the data for your "Spacemilk" item
let mockProduct = Product(
    name: "Spacemilk",
    imageName: "spacemilk", // <-- This MUST match the image name in Assets.xcassets
    shortDescription: "Meet Chocolate. Tasty, clean, guilt-free.",
    whatIsIt: "A sustainable milk alternative.",
    howItWorks: "Made from space oats."
)
