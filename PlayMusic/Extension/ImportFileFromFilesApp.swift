import Foundation
import XCLog

/// if file exists, return false
func ImportFileFromFilesApp(_ filePathInFiles: URL, to filePathInSandbox: URL) -> Bool {
    let fileName = filePathInFiles.lastPathComponent
    XCLog("\(fileName)")

    do {
        if FileManager.default.fileExists(atPath: filePathInSandbox.path) {
            return false
//            try FileManager.default.removeItem(at: filePathInSandbox)
        }

        let isSecurityScoped = filePathInFiles.startAccessingSecurityScopedResource()
        try FileManager.default.copyItem(atPath: filePathInFiles.path, toPath: filePathInSandbox.path)
        if isSecurityScoped {
            filePathInFiles.stopAccessingSecurityScopedResource()
        }
    } catch {
        print("Cannot copy file from \(filePathInFiles.path) to \(filePathInSandbox.path): \(error)")
    }
    return true
}
