// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Eventable",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Eventable",
            targets: ["Eventable"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.9.0")
    ],
    targets: [
        .target(
            name: "Eventable",
            dependencies: [
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            path: "Eventable/Classes"
        )
    ]
)
