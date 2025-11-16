import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // --- Tab 1: Eco Buy ---
            // This is the MainPageView we built
            MainPageView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Eco Buy")
                }
            
            // --- Tab 2: Carbon Calc ---
            // We wrap this in a NavigationStack so it gets a nice title bar
            NavigationStack {
                CarbonCalcView()
            }
                .tabItem {
                    Image(systemName: "function") // Using "f(x)" icon
                    Text("Carbon Calc")
                }
        }
        // This sets the color of the selected tab icon and text
        .accentColor(Color("AppGreen"))
    }
}



#Preview {
    ContentView()
}
