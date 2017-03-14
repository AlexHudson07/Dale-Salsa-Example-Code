import UIKit

class Song: NSObject, NSCoding {
    var name: String!
    var artist: String!
    var artistId: Int!
    var length: Int!
    var songId: Int!
    var songLevel: Int!
    var songType: Int!
    var storeURL: String!
    var counts = [[Double]]()
    var twoFiveAndSevenTimes = [Double]()
    var oneThreeAndSixTimes = [Double]()
    var url: URL!
    var BPM: Int!
    
    init (name: String,
          artist: String,
          artistId: Int,
          bpm: Int,
          songId: Int,
          songLevel: Int,
          songTime: Int,
          songType: Int,
          storeURL: String
        ) {
        super.init()
        self.name = name
        self.artist = artist
        self.artistId = artistId
        self.length = songTime
        self.songId = songId
        self.songLevel = songLevel
        self.songType = songType
        self.storeURL = storeURL
        url = URL(fileURLWithPath: "")
        self.BPM = bpm
        self.counts = getCounts(bpm: bpm, songTime: songTime)
        self.oneThreeAndSixTimes = counts[0] + counts[2] + counts[5]
        self.twoFiveAndSevenTimes = counts[1] + counts[4] + counts[6]
        self.url = songPath(self.name)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: k.name) as? String,
            let artist = decoder.decodeObject(forKey: k.artist) as? String,
            let artistId = decoder.decodeObject(forKey: k.artistId) as? Int,
            let bpm = decoder.decodeObject(forKey: k.BPM) as? Int,
            let songId = decoder.decodeObject(forKey: k.songId) as? Int,
            let songLevel = decoder.decodeObject(forKey: k.songLevel) as? Int,
            let songTime = decoder.decodeObject(forKey: k.length) as? Int,
            let songType = decoder.decodeObject(forKey: k.songType) as? Int,
            let storeURL = decoder.decodeObject(forKey: k.storeURL) as? String
            else { return nil }
        
        self.init (name: name,
                   artist: artist,
                   artistId: artistId,
                   bpm: bpm,
                   songId: songId,
                   songLevel: songLevel,
                   songTime: songTime,
                   songType: songType,
                   storeURL: storeURL)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: k.name)
        coder.encode(self.artist, forKey: k.artist)
        coder.encode(self.artistId, forKey: k.artistId)
        coder.encode(self.BPM, forKey: k.BPM)
        coder.encode(self.length, forKey: k.length)
        coder.encode(self.songId, forKey:k.songId)
        coder.encode(self.songLevel, forKey:k.songLevel)
        coder.encode(self.songType, forKey:k.songType)
        coder.encode(self.storeURL, forKey: k.storeURL)
    }
    
    func getCounts(bpm: Int, songTime: Int) -> [[Double]] {
        // Proprietary code removed
        return [[1]]
    }
    
    func songPath(_ songName: String) -> URL {
        
        let uri = songName + k.songExtention
        var path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        path.appendPathComponent(uri)
        
        return path
    }
}
