// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
  name: "Dependencies",
  products: [],
  dependencies: [
    .package(url: "https://github.com/yonaskolb/Mint.git", .exact("0.17.0")),
  ],
  targets: []
)
