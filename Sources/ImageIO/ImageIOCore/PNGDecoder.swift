/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* PNGDecoder.swift                                     /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 28, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

import CPNG
import Foundation

/**
 * An object that decodes PNG (Portable Network Graphics) images from data.
 */
struct PNGDecoder: Sendable {
  private init() { }
}

extension PNGDecoder {
  /**
   * The shared PNG decoder object for the process.
   */
  static let `default` = PNGDecoder()
}

extension PNGDecoder {
  /**
   * Returns the decoded data from a PNG image.
   *
   * - Parameter data: The image object to decode.
   *
   * - Returns: The decoded image data.
   */
  func decode(from data: Data) throws -> Image {
    var data = data

    return try data.withUnsafeMutableBytes { rawBufferPointer in
      guard let dataPointer = rawBufferPointer.baseAddress?.assumingMemoryBound(
        to: Int8.self
      ) else {
        throw PNGDecoderError.unableLoadData
      }

      var png = png_create_read_struct(
        PNG_LIBPNG_VER_STRING,
        nil,
        nil,
        nil
      )
      var info = png_create_info_struct(png)

      var memoryBuffer = MemoryBuffer(
        buffer: dataPointer,
        size: rawBufferPointer.count,
        offset: 0
      )
      png_set_read_fn(
        png,
        &memoryBuffer,
        { png, data, length in
          /* Custom read function to read from memory buffer. */
          let buffer = png_get_io_ptr(png)
            .assumingMemoryBound(to: MemoryBuffer.self)
          memcpy(
            data,
            buffer.pointee.buffer.advanced(by: buffer.pointee.offset),
            length
          )
          /* Advance the offset. */
          buffer.pointee.offset += length
        }
      )

      png_read_info(png, info)

      let width = Int(png_get_image_width(png, info))
      let height = Int(png_get_image_height(png, info))
      let bitDepth = Int(png_get_bit_depth(png, info))
      let sampleWidth = Int(bitDepth / 8)
      let channelCount = Int(png_get_channels(png, info))

      let rowPointers = malloc(MemoryLayout<png_bytep>.size * Int(height))
        .assumingMemoryBound(to: UnsafeMutablePointer<png_byte>?.self)
      let rowBytes = png_get_rowbytes(png, info)

      for i in 0 ..< height {
        rowPointers[i] = malloc(rowBytes)
          .assumingMemoryBound(to: png_byte.self)
      }

      var image = Image(pixelBuffer: [], width: width, height: height)

      /* Read the image. */
      png_read_image(png, rowPointers)

      for i in 0 ..< height {
        let row = rowPointers[i]!

        for j in 0 ..< width {
          for k in 0 ..< channelCount {
            var sample = UInt16(0)

            for l in 0 ..< sampleWidth {
              sample <<= 8
              sample |= UInt16(row[(j * channelCount + k) * sampleWidth + l])
            }

            image.pixelBuffer.append(
              sampleWidth == 1 ? (sample << 8 | sample) : sample
            )
          }
          /* FIXME: This only works with RGB, not grayscale images. */
          if channelCount < 4 {
            image.pixelBuffer.append(UInt16.max)
          }
        }
      }

      /* Free memory. */
      for i in 0 ..< height {
        rowPointers[i]?.deallocate()
      }
      rowPointers.deallocate()
      png_destroy_read_struct(&png, &info, nil)


      return image
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
