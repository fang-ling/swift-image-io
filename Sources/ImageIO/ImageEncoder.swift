/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* ImageEncoder.swift                                   /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 29, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

import Foundation

/**
 * An object that encodes data as images.
 */
struct ImageEncoder: Sendable {
  private init() { }
}

extension ImageEncoder {
  /**
   * The shared image encoder object for the process.
   */
  static let `default` = ImageEncoder()
}

extension ImageEncoder {
  /**
   * Returns an encoded representation of the data you supply.
   *
   * - Parameters:
   *   - image: The data to encode as image.
   *   - format: The format of image.
   *
   * - Returns: The encoded image data.
   */
  func encode(image: Image, to format: Format) throws -> Data {
    switch format {
    case .png:
      fatalError("Not supported yet.")
    case .jpegxl:
      return try JPEGXLEncoder.default.encode(image: image)
    }
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
