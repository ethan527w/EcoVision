import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let shortDescription: String
    let whatIsIt: String
    let howItWorks: String
    let ingredients: String // Added this!
    let purchaseLink: String // Added this for the URL!
}

// Updated Mock Data with your specific link and ingredients
let mockProduct = Product(
    name: "Spacemilk",
    imageName: "spacemilk",
    shortDescription: "Meet Chocolate. Tasty, clean, guilt-free.",
    whatIsIt: "A sustainable milk alternative that saves 95% of water compared to dairy.",
    howItWorks: "Made from space oats using revolutionary fermentation technology.",
    ingredients: "Water, Space Oats, Cocoa Powder, Sunflower Oil, Pea Protein, Cane Sugar, Sea Salt, Calcium Carbonate.",
    purchaseLink: "https://spacemilk.com?sca_ref=8400176.9seAfaSLSM" // Your link
)
