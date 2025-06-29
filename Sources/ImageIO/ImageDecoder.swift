/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* ImageDecoder.swift                                   /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 28, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

import Foundation

/**
 * An object that decodes images from data.
 */
public struct ImageDecoder: Sendable {
  private init() { }
}

extension ImageDecoder {
  /**
   * The shared image decoder object for the process.
   */
  public static let `default` = ImageDecoder()
}

extension ImageDecoder {
  /**
   * Returns the decoded data from an image.
   *
   * - Parameters:
   *   - data: The image object to decode.
   *   - format: The format of image.
   *
   * - Returns: The decoded image data.
   */
  public func decode(from data: Data, with format: Format) throws -> Image {
    switch format {
    case .png:
      return try PNGDecoder.default.decode(from: data)
    case .jpegxl:
      return try JPEGXLDecoder.default.decode(from: data)
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
