// ProductData.swift（新建文件）
import Foundation

struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let co2PerUnit: Double // 公斤/单位
    let unit: String
    let iconName: String
    var isPartnerProduct: Bool = false
    var productURL: String? = nil // 合作商品专属链接
}

let products = [
    Product(name: "Beef", co2PerUnit: 27.0, unit: "kg", iconName: "fork.knife"),
    Product(name: "Chicken", co2PerUnit: 6.9, unit: "kg", iconName: "bird"),
    Product(name: "Milk", co2PerUnit: 1.9, unit: "L", iconName: "carton"),
    Product(name: "Protein Powder", co2PerUnit: 2.5, unit: "pcs", iconName: "dumbbell",
          isPartnerProduct: true, productURL: "https://www.ecovision.world"),
    Product(name: "T-shirts", co2PerUnit: 5.0, unit: "pcs", iconName: "tshirt"),
    Product(name: "Shoes", co2PerUnit: 8.0, unit: "pairs", iconName: "shoe",
          isPartnerProduct: true, productURL: "https://cto.ecovision.world"),
    Product(name: "Laptops", co2PerUnit: 400.0, unit: "pcs", iconName: "laptopcomputer"),
    Product(name: "Bottles (plastic)", co2PerUnit: 0.1, unit: "pcs", iconName: "waterbottle"),
    Product(name: "Chopsticks", co2PerUnit: 0.3, unit: "pcs", iconName: "chopsticks")
]
