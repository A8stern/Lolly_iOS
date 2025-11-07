//
//  VideoViewModel.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

import Foundation

public final class VideoViewModel {
    public let fileName: String
    public let fileExtension: String
    public let shouldLoop: Bool
    public let isMuted: Bool

    public init(
        fileName: String,
        fileExtension: String = "mp4",
        shouldLoop: Bool = true,
        isMuted: Bool = true
    ) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.shouldLoop = shouldLoop
        self.isMuted = isMuted
    }

    public var fileURL: URL? {
        Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    }
}
