/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* Image.swift                                          /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 28, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

/**
 * A bitmap image.
 */
public struct Image {
  /**
   * A four-channel, 16-bit-per-channel, unsigned-integer interleaved buffer.
   */
  public var pixelBuffer: [UInt16]

  /**
   * The width of a bitmap image, in pixels.
   */
  public var width: Int

  /**
   * The height of a bitmap image, in pixels.
   */
  public var height: Int

  public init(pixelBuffer: [UInt16], width: Int, height: Int) {
    self.pixelBuffer = pixelBuffer
    self.width = width
    self.height = height
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
