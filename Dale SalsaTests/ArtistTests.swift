import XCTest
@testable import Dale_Salsa

class ArtistTests: XCTestCase {
    
    let artist = Artist(name: "alex",
                        id: 3,
                        bio: "the best",
                        pageURL: "a.com")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_artist_Created() {
        XCTAssertNotNil(artist)
    }
    
    func test_artist_Info_Is_Accurate() {
        XCTAssertEqual(artist.name, "alex")
        XCTAssertEqual(artist.id, 3)
        XCTAssertEqual(artist.bio, "the best")
        XCTAssertEqual(artist.pageURL, "a.com")
    }
    
    func test_artist_Can_Be_Serialzed() {
        let serialized = NSKeyedArchiver.archivedData(withRootObject: artist)
        do {
            try serialized.write(to: getTestURL(), options: .atomic)
        } catch {
            XCTFail()
        }
    }
    
    func test_song_Can_Be_Unserialized() {
        let serialized = NSKeyedArchiver.archivedData(withRootObject: artist)
        try? serialized.write(to: getTestURL(), options: .atomic)
        do {
            let data = try Data(contentsOf: getTestURL(), options: .mappedIfSafe)
            
            let unarchivedArtist = NSKeyedUnarchiver.unarchiveObject(with: data) as! Artist
            
            XCTAssertEqual(unarchivedArtist.name, "alex")
            XCTAssertEqual(unarchivedArtist.id, 3)
            XCTAssertEqual(unarchivedArtist.bio, "the best")
            XCTAssertEqual(unarchivedArtist.pageURL, "a.com")
          
        } catch {
            XCTFail()
        }
    }

    func getTestURL() -> URL {
        let directory = FileManager.default.urls(for: .libraryDirectory,
                                                 in: .userDomainMask)[0]
        
        let path = directory.appendingPathComponent("TestArtistInfo").path
        return URL(fileURLWithPath: path)
    }

    //MARK: Artist+Parse
    func test_init_Aritst_From_Dictionary() {
        let source:[String:Any] = [k.artistName: "alex",
                                   k.artistId: 5,
                                   k.artistBio: "John 3:16",
                                   k.artistPageURL: "b.com"]
        
        let artist = try? Artist(fromDictionary: source)
        
        XCTAssertEqual(artist?.name, "alex")
        XCTAssertEqual(artist?.id, 5)
        XCTAssertEqual(artist?.bio, "John 3:16")
        XCTAssertEqual(artist?.pageURL, "b.com")
    }
}
