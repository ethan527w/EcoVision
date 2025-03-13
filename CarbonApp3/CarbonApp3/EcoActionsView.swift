// EcoActionsView.swift（新建文件）
import SwiftUI

struct EcoActionsView: View {
    @State private var searchText = ""
    @State private var selectedProduct: Product?
    @State private var quantity: String = ""
    
    private var filteredProducts: [Product] {
        searchText.isEmpty ? products : products.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var totalEmission: Double {
        guard let product = selectedProduct,
              let qty = Double(quantity) else { return 0 }
        return qty * product.co2PerUnit
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 标题
                Text("Sustainable Shopping")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // 搜索栏
                TextField("Search products...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .autocorrectionDisabled()
                
                // 商品选择列表
                List(filteredProducts) { product in
                    HStack {
                        Image(systemName: product.iconName)
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text("\(product.co2PerUnit, specifier: "%.1f") kg/\(product.unit)")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        if product.isPartnerProduct {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                        }
                        
                        if selectedProduct == product {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { selectedProduct = product }
                }
                .listStyle(.plain)
                
                // 数量输入
                VStack(alignment: .leading) {
                    Text("Amount (\(selectedProduct?.unit ?? "Unit"))")
                        .font(.headline)
                    TextField("Type an integer", text: $quantity)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                .opacity(selectedProduct != nil ? 1 : 0)
                
                // 计算结果和合作链接
                if selectedProduct != nil && !quantity.isEmpty {
                    VStack(spacing: 15) {
                        Text("Total Carbon Emission")
                            .font(.title2)
                        
                        Text("\(totalEmission, specifier: "%.1f") kg CO₂")
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        // 合作商品专属按钮
                        if let product = selectedProduct,
                           product.isPartnerProduct,
                           let urlString = product.productURL,
                           let url = URL(string: urlString) {
                            
                            VStack {
                                Text("✨ Check our low-carb partner ✨")
                                    .font(.caption)
                                
                                Link(destination: url) {
                                    HStack {
                                        Image(systemName: "link")
                                        Text("Check details")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .transition(.opacity)
                }
                
                Spacer()
            }
            .navigationTitle("Actions, NOW")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Reset") {
                        selectedProduct = nil
                        quantity = ""
                    }
                }
            }
            .animation(.easeInOut, value: selectedProduct)
        }
    }
}

#Preview {
    EcoActionsView()
}
