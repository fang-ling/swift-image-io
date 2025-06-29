/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* JPEGXLDecoder.swift                                  /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 28, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

import CJPEGXL
import Foundation

/**
 * An object that decodes JPEG XL images from data.
 */
struct JPEGXLDecoder: Sendable {
  private init() { }
}

extension JPEGXLDecoder {
  /**
   * The shared JPEG XL decoder object for the process.
   */
  static let `default` = JPEGXLDecoder()
}

extension JPEGXLDecoder {
  /**
   * Returns the decoded data from a JPEG XL image.
   *
   * - Parameter data: The image object to decode.
   *
   * - Returns: The decoded image data.
   */
  func decode(from data: Data) throws -> Image {
    var data = data

    /* TODO: Replace fatalError */
    return try data.withUnsafeMutableBytes { rawBufferPointer in
      guard let dataPointer = rawBufferPointer.baseAddress?.assumingMemoryBound(
        to: Int8.self
      ) else {
        throw PNGDecoderError.unableLoadData
      }

      /* Multi-threaded parallel runner. */
      let runner = JxlResizableParallelRunnerCreate(nil)

      let decoder = JxlDecoderCreate(nil)
      JxlDecoderSubscribeEvents(
        decoder,
        Int32(JXL_DEC_BASIC_INFO.rawValue) | Int32(JXL_DEC_FULL_IMAGE.rawValue)
      )

      JxlDecoderSetParallelRunner(decoder,
                                  JxlResizableParallelRunner,
                                  runner)

      JxlDecoderSetInput(decoder, dataPointer, rawBufferPointer.count)
      JxlDecoderCloseInput(decoder)

      var info = JxlBasicInfo()
      var format = JxlPixelFormat(
        num_channels: 4,
        data_type: JXL_TYPE_UINT16,
        endianness: JXL_NATIVE_ENDIAN,
        align: 0
      )

      var width = 0
      var height = 0

      var bufferSize = 0
      var pixelData: UnsafeMutablePointer<UInt16>? = nil

      var status: JxlDecoderStatus
      while true {
        status = JxlDecoderProcessInput(decoder)
        if status == JXL_DEC_SUCCESS {
          break
        } else if status == JXL_DEC_ERROR {
          fatalError("Decoding error")
        } else if status == JXL_DEC_NEED_MORE_INPUT {
          fatalError("Need more input, but we already provided all data")
        } else if status == JXL_DEC_BASIC_INFO {
          if JxlDecoderGetBasicInfo(decoder, &info) != JXL_DEC_SUCCESS {
            fatalError("Failed to get basic info")
          }
          width = Int(info.xsize)
          height = Int(info.ysize)
        } else if status == JXL_DEC_NEED_IMAGE_OUT_BUFFER {
          if JxlDecoderImageOutBufferSize(
            decoder,
            &format,
            &bufferSize
          ) != JXL_DEC_SUCCESS {
            fatalError("Failed to get output buffer size")
          }
          pixelData = malloc(bufferSize).assumingMemoryBound(to: UInt16.self)
          if pixelData == nil {
            fatalError("Failed to allocate memory for pixel data")
          }
          if JxlDecoderSetImageOutBuffer(
            decoder,
            &format,
            pixelData,
            bufferSize
          ) != JXL_DEC_SUCCESS {
            fatalError("Failed to set output buffer")
          }
        }
      }

      if status != JXL_DEC_SUCCESS && status != JXL_DEC_FULL_IMAGE {
        fatalError("Failed to decode image")
      }

      var image = Image(pixelBuffer: [], width: width, height: height)
      for i in 0 ..< bufferSize / MemoryLayout<UInt16>.size {
        image.pixelBuffer.append(pixelData?[i] ?? 0)
      }

      pixelData?.deallocate()
      JxlResizableParallelRunnerDestroy(runner)
      JxlDecoderDestroy(decoder)

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
