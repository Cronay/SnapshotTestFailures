//
//  XCTestCase+Snapshots.swift
//  zewis_mobileTests
//
//  Created by Cronay on 03.05.21.
//  Copyright © 2021 PAS UG. All rights reserved.
//

import XCTest

extension XCTestCase {

    func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshot = UIImage(contentsOfFile: snapshotURL.path) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }

        if !compare(storedSnapshot, snapshot, precision: 0.9999994) {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)

            try? snapshotData?.write(to: temporarySnapshotURL)

            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }

    func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )

            try snapshotData?.write(to: snapshotURL)
            XCTFail("Record succeeded - use `assert` to compare the snapshot from now on.", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }

    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }

    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }

        return data
    }

    private func compare(_ old: UIImage, _ new: UIImage, precision: Float) -> Bool {
      guard let oldCgImage = old.cgImage else { return false }
      guard let newCgImage = new.cgImage else { return false }
      guard oldCgImage.width != 0 else { return false }
      guard newCgImage.width != 0 else { return false }
      guard oldCgImage.width == newCgImage.width else { return false }
      guard oldCgImage.height != 0 else { return false }
      guard newCgImage.height != 0 else { return false }
      guard oldCgImage.height == newCgImage.height else { return false }
      // Values between images may differ due to padding to multiple of 64 bytes per row,
      // because of that a freshly taken view snapshot may differ from one stored as PNG.
      // At this point we're sure that size of both images is the same, so we can go with minimal `bytesPerRow` value
      // and use it to create contexts.
      let minBytesPerRow = min(oldCgImage.bytesPerRow, newCgImage.bytesPerRow)
      let byteCount = minBytesPerRow * oldCgImage.height

      var oldBytes = [UInt8](repeating: 0, count: byteCount)
      guard let oldContext = context(for: oldCgImage, bytesPerRow: minBytesPerRow, data: &oldBytes) else { return false }
      guard let oldData = oldContext.data else { return false }
      if let newContext = context(for: newCgImage, bytesPerRow: minBytesPerRow), let newData = newContext.data {
        if memcmp(oldData, newData, byteCount) == 0 { return true }
      }
      let newer = UIImage(data: new.pngData()!)!
      guard let newerCgImage = newer.cgImage else { return false }
      var newerBytes = [UInt8](repeating: 0, count: byteCount)
      guard let newerContext = context(for: newerCgImage, bytesPerRow: minBytesPerRow, data: &newerBytes) else { return false }
      guard let newerData = newerContext.data else { return false }
      if memcmp(oldData, newerData, byteCount) == 0 { return true }
      if precision >= 1 { return false }
      var differentPixelCount = 0
      let threshold = 1 - precision
      for byte in 0..<byteCount {
        if oldBytes[byte] != newerBytes[byte] { differentPixelCount += 1 }
        if Float(differentPixelCount) / Float(byteCount) > threshold { return false}
      }
      return true
    }

    private func context(for cgImage: CGImage, bytesPerRow: Int, data: UnsafeMutableRawPointer? = nil) -> CGContext? {
      guard
        let space = cgImage.colorSpace,
        let context = CGContext(
          data: data,
          width: cgImage.width,
          height: cgImage.height,
          bitsPerComponent: cgImage.bitsPerComponent,
          bytesPerRow: bytesPerRow,
          space: space,
          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        else { return nil }

      context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
      return context
    }

}
