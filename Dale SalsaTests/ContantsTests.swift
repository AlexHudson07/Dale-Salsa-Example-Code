import XCTest
@testable import Dale_Salsa

class ContantsTests: XCTestCase {
    
    func test_inDevelopment() {
        XCTAssertFalse(k.inDevelopment)
    }
    
    func test_datebaseChild_Songs() {
        XCTAssertEqual(k.datebaseSongs, "Songs")
    }
    
    func test_datebaseChild_aritstInfo() {
        XCTAssertEqual(k.databaseArtists, "artistInfo")
    }
    
    func test_accurateRange() {
        XCTAssertEqual(k.accurateRange, 0.18)
    }
    
    func test_almostAccurateRange() {
        XCTAssertEqual(k.almostAccurateRange, 0.25)
    }
    
    //MARK: - song
    func test_name() {
        XCTAssertEqual(k.name, "Name")
    }
    
    func test_artist() {
        XCTAssertEqual(k.artist, "Artist")
    }
    
    func test_BPM() {
        XCTAssertEqual(k.BPM, "BPM")
    }
    
    func test_length() {
        XCTAssertEqual(k.length, "Length" )
    }
    
    //MARK: - artist
    
    func test_artistName() {
        XCTAssertEqual(k.artistName, "artistName")
    }
    
    func test_artistId() {
        XCTAssertEqual(k.artistId, "artistId")
    }
    
    func test_artistBio() {
        XCTAssertEqual(k.artistBio, "bio")
    }
    
    func test_artistPageURL() {
        XCTAssertEqual(k.artistPageURL, "facebookPageURL")
    }
    
    func test_songExtension() {
        XCTAssertEqual(k.songExtention, ".mp3" )
    }
    
    func test_songsInfoLocation() {
        XCTAssertEqual(k.songsInfoLocation, "SongsInfo" )
    }
    
    func test_firstSongName() {
        XCTAssertEqual(k.firstSongName, "UnoDosTres")
    }
    
    func test_gender() {
        XCTAssertEqual(k.gender, "userIsLady")
    }
    
    func test_tapViewController() {
        XCTAssertEqual(k.tapViewController, "TapViewController")
    }
    
    func test_sideMenuViewController() {
        XCTAssertEqual(k.sideMenuViewController, "SideMenuViewController")
    }
    
    func test_tutorialComplete() {
        XCTAssertEqual(k.tutorialComplete, "userWentThroughTutorial")
    }
    
    func test_guideTimeInterval() {
        XCTAssertEqual(k.guideTimeInterval, 0.2)
    }
    
    func test_parallaxHorizontalAxis() {
        XCTAssertEqual(k.parallaxHorizontalAxis, "center.x")
    }
    
    func test_parallaxVerticalAxis() {
        XCTAssertEqual(k.parallaxVerticalAxis, "center.y")
    }
    
    func test_storageReference() {
        XCTAssertEqual(k.storageReference, "gs://dale-salsa.appspot.com/")
    }
    
    func test_songCellCell() {
        XCTAssertEqual(k.songCell, "SongCell")
    }
    
    func test_songCellCellId() {
        XCTAssertEqual(k.songCellId, "songCellId")
    }
    
    func test_slideLeftCell() {
        XCTAssertEqual(k.slideLeftCell, "SlideLeftCell")
    }
    
    func test_slideLeftCellId() {
        XCTAssertEqual(k.slideLeftCellId, "slideLeftCellId")
    }
}
