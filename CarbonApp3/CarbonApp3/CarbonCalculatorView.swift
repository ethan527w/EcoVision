// CarbonCalculatorView.swift（新建文件）
import SwiftUI

struct CarbonCalculatorView: View {
    @State private var searchText = ""
    @State private var selectedTransport: Transportation?
    @State private var kilometers: String = ""
    
    private var filteredTransports: [Transportation] {
        if searchText.isEmpty {
            return transportations
        } else {
            return transportations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private var carbonFootprint: Double {
        guard let transport = selectedTransport,
              let km = Double(kilometers) else { return 0 }
        return km * transport.co2PerKm
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 标题
                Text("Where did you go?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // 输入公里数
                VStack(alignment: .leading) {
                    Text("Distance (km)")
                        .font(.headline)
                    TextField("Type some numbers here (e.g. 100)", text: $kilometers)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                // 搜索栏
                TextField("Search your traffic tool", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                // 交通工具列表
                List(filteredTransports) { transport in
                    HStack {
                        Image(systemName: transport.iconName)
                            .foregroundColor(.green)
                            .frame(width: 30)
                        
                        Text(transport.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(transport.co2PerKm, specifier: "%.2f") kg/km")
                            .foregroundColor(.gray)
                        
                        if selectedTransport == transport {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTransport = transport
                    }
                }
                .listStyle(.plain)
                
                // 计算结果
                VStack {
                    Text("Approximation")
                        .font(.title2)
                    
                    Text("\(carbonFootprint, specifier: "%.2f") kg CO₂")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                        .padding()
                }
                .opacity(selectedTransport != nil && !kilometers.isEmpty ? 1 : 0)
                
                Spacer()
            }
            .navigationTitle("Carbon Calculator")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Reset") {
                        selectedTransport = nil
                        kilometers = ""
                    }
                }
            }
        }
    }
}

#Preview {
    CarbonCalculatorView()
}
