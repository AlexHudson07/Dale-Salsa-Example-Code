import UIKit

extension Song {
    convenience init(fromDictionary source: [String:Any]) throws {
        guard
            let artist = source[k.artist] as? String,
            let artistId = source[k.artistId] as? Int,
            let bpm = source[k.BPM] as? Int,
            let length = source[k.length] as? Int,
            let name = source[k.name] as? String,
            let songId = source[k.songId] as? Int,
            let songLevel = source[k.songLevel] as? Int,
            let songType = source[k.songType] as? Int,
            let storeURL = source[k.storeURL] as? String
            else { throw ParseError.missingValueOrIncorrectValueType(message: String(describing: Song.self)) }
        
        self.init (
        name: name,
        artist: artist,
        artistId: artistId,
        bpm: bpm,
        songId: songId,
        songLevel: songLevel,
        songTime: length,
        songType: songType,
        storeURL: storeURL
        )
    }

    enum ParseError: Error {
        case missingValueOrIncorrectValueType(message: String)
        case incorrectDataType(message: String)
        
        func getError() -> NSError {
            let errorMessage: String
            switch(self) {
            case .missingValueOrIncorrectValueType(let message):
                errorMessage = message
            case .incorrectDataType(let message):
                errorMessage = message
            }
            let domain = "Unable to parse service data: \(errorMessage)"
            return NSError(domain: domain, code: 0, userInfo: nil)
        }
    }
}
