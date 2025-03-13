import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 顶部标题
                Text("ECO VISION")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 40)
                
                Spacer()
                
                // 上半部分按钮
                NavigationLink {
                    CarbonCalculatorView()
                    Text("Eco Calculator")
                } label: {
                    BigButtonView(title: "Carbon Calculator", icon: "leaf.fill")
                }
                
                
                // 中间部分按钮
                NavigationLink {
                    // 后续可以添加跳转目标视图
                    Text("Eco Buy")
                } label: {
                    BigButtonView(title: "Eco Buy", icon: "")
                }
                
                
                // 下半部分按钮
                NavigationLink {
                    EcoActionsView()
                    Text("Eco Actions")
                } label: {
                    BigButtonView(title: "Eco Actions", icon: "bolt.fill")
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

// 自定义大按钮组件
struct BigButtonView: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(.title2)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.green)    
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
