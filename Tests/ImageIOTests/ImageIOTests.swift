/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* ImageIOTests.swift                                   /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 28, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

@testable import ImageIO
import Testing

struct ImageEncoderTests {
  @Test func testLosslessEncoding() async throws {
    let image = Image(
      pixelBuffer: (
        [UInt16](repeating: 19348, count: 1280 * 720) +
        [UInt16](repeating: 12361, count: 1280 * 720) +
        [UInt16](repeating: 19358, count: 1280 * 720) +
        [UInt16](repeating: 12333, count: 1280 * 720)
      ),
      width: 1280,
      height: 720
    )

    let jxlData = try ImageEncoder.default.encode(image: image, to: .jpegxl)
    let decodedImage = try ImageDecoder.default.decode(
      from: jxlData,
      with: .jpegxl
    )

    #expect(decodedImage == image)
  }
}

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
