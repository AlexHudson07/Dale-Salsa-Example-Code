class SongManager {
    
    static let sharedInstance: SongManager = {
        let instance = SongManager()
        instance.getSongsFromLibrary()
        return instance
    }()
    
    private(set) var listOfSongs = [Song(name: "UnoDosTres",
                                         artist: "",
                                         artistId: 3,
                                         bpm: 160,
                                         songId: 1,
                                         songLevel: 1,
                                         songTime: 243,
                                         songType: 1,
                                         storeURL: "www")] {
        didSet {
            let song = Song(name: "UnoDosTres",
                            artist: "",
                            artistId: 3,
                            bpm: 160,
                            songId: 1,
                            songLevel: 1,
                            songTime: 243,
                            songType: 1,
                            storeURL: "www")

            if listOfSongs.count == 0 {
                listOfSongs.append(song)
            }
        }
    }
    
    private init() {}
    
    private func getSongsFromLibrary(location: String = k.songsInfoLocation) {
        let directory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let path = directory.appendingPathComponent(k.songsInfoLocation).path
        let url = URL(fileURLWithPath: path)
        
        if let data = try? Data(contentsOf: url, options: .mappedIfSafe)
        {
            listOfSongs = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Song]
        }
    }
    
    func saveToLibrary(songs: [Song], location: String = k.songsInfoLocation) {
        let directory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let path = directory.appendingPathComponent(k.songsInfoLocation).path
        let url = URL(fileURLWithPath: path)
        
        let serialized = NSKeyedArchiver.archivedData(withRootObject: songs)
        do {
            try serialized.write(to: url, options: .atomic)
        } catch let error as NSError {
            print(error)
        }
    }
}
