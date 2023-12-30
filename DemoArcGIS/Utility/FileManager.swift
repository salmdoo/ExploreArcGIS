//
//  FileManager.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/29/23.
//

import Foundation

extension FileManager {
    /// Creates a temporary directory and returns the URL of the created directory.
    static func createTemporaryDirectory() -> URL {
        // swiftlint:disable:next force_try
        try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true
        )
    }
    
    static func createMMPKTemporaryDirectory(temporaryDirectory: URL, fileName: String?) -> URL? {
        if let fileName {
           return temporaryDirectory
                .appendingPathComponent(fileName)
                .appendingPathExtension("mmpk")
        } else {
            return nil
        }
    }
}
