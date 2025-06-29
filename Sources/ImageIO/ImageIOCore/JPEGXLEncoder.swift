/*===----------------------------------------------------------------------===*/
/*                                                        ___   ___           */
/* JPEGXLEncoder.swift                                  /'___\ /\_ \          */
/*                                                     /\ \__/ \//\ \         */
/* Author: Fang Ling (fangling@fangl.ing)              \ \ ,__\  \ \ \        */
/* Date: June 29, 2025                                  \ \ \_/__ \_\ \_  __  */
/*                                                       \ \_\/\_\/\____\/\_\ */
/* Copyright (c) 2025-2025 Fang Ling All Rights Reserved. \/_/\/_/\/____/\/_/ */
/*===----------------------------------------------------------------------===*/

import CJPEGXL
import Foundation

/**
 * An object that encodes data as JPEG XL images.
 */
struct JPEGXLEncoder: Sendable {
  private init() { }
}

extension JPEGXLEncoder {
  /**
   * The shared JPEG XL encoder object for the process.
   */
  static let `default` = JPEGXLEncoder()
}

extension JPEGXLEncoder {
  /**
   * Returns a JPEG XL encoded representation of the data you supply.
   *
   * - Parameter image: The data to encode as JPEG XL.
   *
   * - Returns: The encoded JPEG XL data.
   */
  func encode(image: Image) throws -> Data {
    let encoder = JxlEncoderCreate(nil)
    if encoder == nil {
      fatalError("Failed to create JxlEncoder")
    }

    let runner = JxlResizableParallelRunnerCreate(nil)
    JxlEncoderSetParallelRunner(encoder, JxlResizableParallelRunner, runner)

    /* Add a new frame for encoding. */
    let frameSettings = JxlEncoderFrameSettingsCreate(encoder, nil)
    if frameSettings == nil {
      fatalError("Failed to create frame settings")
    }

    /* Configure lossless encoding. */
    if JxlEncoderSetFrameLossless(frameSettings, 1) != JXL_ENC_SUCCESS {
      fatalError("Failed to set lossless encoding")
    }

    /* Set basic image information. */
    var info = JxlBasicInfo()
    JxlEncoderInitBasicInfo(&info)
    info.xsize = UInt32(image.width)
    info.ysize = UInt32(image.height)
    info.bits_per_sample = 16 /* Currently we only use 16 bits per sample. */
    info.alpha_bits = 16
    info.num_color_channels = 3 /* RGB */
    info.num_extra_channels = 1 /* Alpha */
    info.uses_original_profile = JXL_TRUE

    if JxlEncoderSetBasicInfo(encoder, &info) != JXL_ENC_SUCCESS {
      fatalError("Failed to set basic info")
    }

    /* Define the pixel format (RGBA, 16 bits per channel). */
    var pixelFormat = JxlPixelFormat(
      num_channels: 4,
      data_type: JXL_TYPE_UINT16,
      endianness: JXL_NATIVE_ENDIAN, /* FIXME: We may care about the endian? */
      align: 0
    )

    /* Add the RGBA buffer to the encoder. */
    if JxlEncoderAddImageFrame(
      frameSettings,
      &pixelFormat,
      image.pixelBuffer,
      image.pixelBuffer.count * MemoryLayout<UInt16>.size
    ) != JXL_ENC_SUCCESS {
      fatalError("Failed to add image frame")
    }

    /* Finalize the encoder's input */
    JxlEncoderCloseInput(encoder)

    /* Prepare the output buffer. */
    var buffer: UnsafeMutablePointer<UInt8>? = malloc(64)
      .assumingMemoryBound(to: UInt8.self)
    var bufferSize = 64
    var outputData = Data()
    var nextOut = buffer
    var availOut = bufferSize

    var status = JXL_ENC_NEED_MORE_OUTPUT
    while status == JXL_ENC_NEED_MORE_OUTPUT {
      status = JxlEncoderProcessOutput(encoder, &nextOut, &availOut)

      if status == JXL_ENC_NEED_MORE_OUTPUT {
        /* nextOut - buffer */
        let offset = buffer!.distance(to: nextOut!)
        bufferSize *= 2
        buffer = realloc(buffer, bufferSize).assumingMemoryBound(to: UInt8.self)

        nextOut = buffer?.advanced(by: offset)
        availOut = bufferSize - offset

      } else if status == JXL_ENC_ERROR {
        fatalError("error")
      }
    }

    /* nextOut - buffer */
    bufferSize = buffer!.distance(to: nextOut!)
    outputData.append(buffer!, count: bufferSize)

    if status != JXL_ENC_SUCCESS {
      fatalError("Failed to encode image")
    }

    /* Cleanup */
    JxlResizableParallelRunnerDestroy(runner)
    JxlEncoderDestroy(encoder)

    return outputData
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
