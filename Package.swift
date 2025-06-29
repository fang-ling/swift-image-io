// swift-tools-version: 6.1

/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* Package.swift                                        /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 28, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

import PackageDescription

let package = Package(
  name: "swift-image-io",
  platforms: [.macOS(.v11)],
  products: [
    .library( name: "ImageIO", targets: ["ImageIO"])
  ],
  dependencies: [
    .package(url: "https://github.com/fang-ling/swift-png", from: "1.0.0-beta.1"),
    .package(url: "https://github.com/fang-ling/swift-jpeg-xl", from: "1.0.0-beta.2")
  ],
  targets: [
    .target(
      name: "ImageIO",
      dependencies: [
        .product(name: "CPNG", package: "swift-png"),
        .product(name: "CJPEGXL", package: "swift-jpeg-xl")
      ]
    ),
    .testTarget(
      name: "ImageIOTests",
      dependencies: ["ImageIO"]
    )
  ]
)

/*===----------------------------------------------------------------------===*/
/*     ______                                       ______   _____            */
/*    /\__  _\                                     /\__  _\ /\  __`\          */
/*    \/_/\ \/     ___ ___      __       __      __\/_/\ \/ \ \ \/\ \         */
/*       \ \ \   /' __` __`\  /'__`\   /'_ `\  /'__`\ \ \ \  \ \ \ \ \        */
/*        \_\ \__/\ \/\ \/\ \/\ \L\.\_/\ \L\ \/\  __/  \_\ \__\ \ \_\ \       */
/*        /\_____\ \_\ \_\ \_\ \__/.\_\ \____ \ \____\ /\_____\\ \_____\      */
/*        \/_____/\/_/\/_/\/_/\/__/\/_/\/___L\ \/____/ \/_____/ \/_____/      */
/*                                       /\____/                              */
/*                                       \_/__/                               */
/*===----------------------------------------------------------------------===*/
