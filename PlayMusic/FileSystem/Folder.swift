import Foundation

let DocumentFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let DocumentMusicFolder = DocumentFolder.appendingPathComponent("Music")
