import XCTest
@testable import Dale_Salsa

class SongTests: XCTestCase {
    
    let song = Song(name: "Tu Sin Mi",
                    artist: "Alex",
                    artistId: 1,
                    bpm: 160,
                    songId: 9,
                    songLevel: 2,
                    songTime: 100,
                    songType: 2,
                    storeURL: "a.com")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Song_Info_Created() {
        XCTAssertNotNil(song)
    }
    
    func test_Song_Info_Is_Accurate() {
        XCTAssertEqual(song.name, "Tu Sin Mi")
        XCTAssertEqual(song.artist, "Alex")
        XCTAssertEqual(song.artistId, 1)
        XCTAssertEqual(song.BPM, 160)
        XCTAssertEqual(song.songId, 9)
        XCTAssertEqual(song.songLevel, 2)
        XCTAssertEqual(song.length, 100)
        XCTAssertEqual(song.songType, 2)
        XCTAssertEqual(song.storeURL, "a.com")
        XCTAssertEqual(song.counts.count, 8)
    }
    
    func test_song_URL_Is_Accurate() {
        var path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        path.appendPathComponent(song.name + k.songExtention)
        
        XCTAssertEqual(song.url, path)
    }
    
    func test_song_Can_Be_Serialzed() {
        let serialized = NSKeyedArchiver.archivedData(withRootObject: song)
        do {
            try serialized.write(to: getTestURL(), options: .atomic)
        } catch {
            XCTFail()
        }
    }
    
    func test_song_Can_Be_Unserialized() {
        let serialized = NSKeyedArchiver.archivedData(withRootObject: song)
        try? serialized.write(to: getTestURL(), options: .atomic)
        do {
            let data = try Data(contentsOf: getTestURL(), options: .mappedIfSafe)

            let unarchivedSong = NSKeyedUnarchiver.unarchiveObject(with: data) as! Song
            
            XCTAssertEqual(unarchivedSong.name, "Tu Sin Mi")
            XCTAssertEqual(unarchivedSong.artist, "Alex")
            XCTAssertEqual(unarchivedSong.artistId, 1)
            XCTAssertEqual(unarchivedSong.BPM, 160)
            XCTAssertEqual(unarchivedSong.songId, 9)
            XCTAssertEqual(unarchivedSong.songLevel, 2)
            XCTAssertEqual(unarchivedSong.length, 100)
            XCTAssertEqual(unarchivedSong.songType, 2)
            XCTAssertEqual(unarchivedSong.storeURL, "a.com")
            XCTAssertEqual(unarchivedSong.counts.count, 8)
        } catch {
            XCTFail()
        }
    }
    
    func test_getCounts_Return_8_Counts() {
        let counts = song.getCounts(bpm: 60, songTime: 60)
        
        XCTAssertEqual(counts.count, 8)
    }
    
    func test_getCounts_Returns_Accurate_Ccounts() {
        let counts = song.getCounts(bpm: 60, songTime: 30)

        XCTAssertEqual(counts[0], [1.0, 9.0,  17.0])
        XCTAssertEqual(counts[1], [2.0, 10.0, 18.0])
        XCTAssertEqual(counts[2], [3.0, 11.0, 19.0])
        XCTAssertEqual(counts[3], [4.0, 12.0, 20.0])
        XCTAssertEqual(counts[4], [5.0, 13.0, 21.0])
        XCTAssertEqual(counts[5], [6.0, 14.0, 22.0])
        XCTAssertEqual(counts[6], [7.0, 15.0, 23.0])
        XCTAssertEqual(counts[7], [8.0, 16.0, 24.0])
    }
    
    func test_songPath_Returns_Correct_URL() {
        let testSong = "sampleSong"
        let uri = testSong + k.songExtention
        var path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        path.appendPathComponent(uri)

        let testPath = song.songPath(testSong)
        
        XCTAssertEqual(testPath, path)
    }
    
    func getTestURL() -> URL {
        let directory = FileManager.default.urls(for: .libraryDirectory,
                                                 in: .userDomainMask)[0]
        
        let path = directory.appendingPathComponent("TestSongsInfo").path
        return URL(fileURLWithPath: path)
    }
    
    //MARK: - Song+Parse
    func test_init_Song_From_Dictionary() {
        let source:[String:Any] = [k.artist: "alex",
                      k.artistId: 4,
                      k.BPM: 40,
                      k.length: 90,
                      k.name: "song1",
                      k.songId: 8,
                      k.songLevel: 5,
                      k.songType: 67,
                      k.storeURL: "a.com"]
        
        let song = try? Song(fromDictionary: source)
        
        XCTAssertEqual(song?.name, "song1")
        XCTAssertEqual(song?.artist, "alex")
        XCTAssertEqual(song?.artistId, 4)
        XCTAssertEqual(song?.BPM, 40)
        XCTAssertEqual(song?.songId, 8)
        XCTAssertEqual(song?.songLevel, 5)
        XCTAssertEqual(song?.length, 90)
        XCTAssertEqual(song?.songType, 67)
        XCTAssertEqual(song?.storeURL, "a.com")
        XCTAssertEqual(song?.counts.count, 8)
    }    
}
