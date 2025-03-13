// TransportationData.swift（新建文件）
import Foundation

struct Transportation: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let co2PerKm: Double // 公斤/公里
    let iconName: String
}

let transportations = [
    Transportation(name: "Foot", co2PerKm: 0.0, iconName: "figure.walk"),
    Transportation(name: "Bicycle", co2PerKm: 0.0, iconName: "bicycle"),
    Transportation(name: "E Motorcycle", co2PerKm: 0.02, iconName: "scooter"),
    Transportation(name: "E Cars", co2PerKm: 0.12, iconName: "bolt.car"),
    Transportation(name: "Hybrid Cars", co2PerKm: 0.25, iconName: "car"),
    Transportation(name: "Fuel Cars", co2PerKm: 0.42, iconName: "fuelpump"),
    Transportation(name: "Diesel Cars", co2PerKm: 0.45, iconName: "fuelpump.fill"),
    Transportation(name: "Buses", co2PerKm: 0.18, iconName: "bus"),
    Transportation(name: "Underground", co2PerKm: 0.05, iconName: "tram"),
    Transportation(name: "Train", co2PerKm: 0.08, iconName: "train.side.front.car"),
    Transportation(name: "Air (Economy)", co2PerKm: 0.25, iconName: "airplane"),
    Transportation(name: "Motor", co2PerKm: 0.35, iconName: "figure.surfing")
]
