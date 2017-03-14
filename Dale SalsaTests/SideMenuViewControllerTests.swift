import XCTest
import Firebase
import MessageUI

@testable import Dale_Salsa

class SideMenuViewControllerTests: XCTestCase {
    
    var controller: SideMenuViewController!
    
    override func setUp() {
        super.setUp()
        
        controller = SideMenuViewController()
        _ = controller.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //MARK: - Init
    func test_songsLabel_Is_Connected() {
        XCTAssertNotNil(controller.songsLabel)
    }

    func test_tableView_Is_Connected() {
        XCTAssertNotNil(controller.tableView)
    }

    func test_tableViewWidthContraint_Is_Connected() {
        XCTAssertNotNil(controller.tableViewWidthContraint)
    }

    func test_feedbackButton_Is_Connected() {
        XCTAssertNotNil(controller.feedbackButton)
    }

    func test_tutorialButton_Is_Connected() {
        XCTAssertNotNil(controller.tutorialButton)
    }
    
    func test_defaults_Are_Set() {
        XCTAssertNotNil(controller.defaults)
    }
    
    func test_songs_Are_Set() {
        XCTAssertNotNil(controller.songs)
        XCTAssertTrue(controller.songs.count >= 1)
    }
    
    func test_dataBase_Is_Set() {
        XCTAssertNotNil(controller.dataBase)
    }
    
    func test_storage_Is_Set() {
        XCTAssertNotNil(controller.storage)
    }
    
    func test_manager_Is_Set() {
        XCTAssertNotNil(controller.manager)
    }
    
    func test_defaultDirectory_Is_Set() {
        XCTAssertNotNil(controller.defaultDirictory)
    }
    
    func test_defaultDomain_Is_Set() {
        XCTAssertNotNil(controller.defaultDomain)
    }
    
    func test_defaulURLIndex_Is_Set() {
        XCTAssertEqual(controller.defaultURLIndex, 0)
    }

    func test_unlockedSongs_Is_false() {
        XCTAssertFalse(controller.unlockedSongs)
    }

    func test_viewDidLoad_Sets_Text() {

        XCTAssertEqual(controller.songsLabel.text,
                       NSLocalizedString("sideMenu-viewController.songs-label.text", comment: ""))

        XCTAssertEqual(controller.feedbackButton.title(for: .normal),
                       NSLocalizedString("sideMenu-viewController.feedback-button.title", comment: ""))

        XCTAssertEqual(controller.tutorialButton.title(for: .normal),
                       NSLocalizedString("sideMenu-viewController.tutorial-button.title", comment: ""))
    }

    //MARK: - Firebase calls
    
    //MARK: - File System
    func test_songIsDownloaded_Returns_true_For_First_Song(){
        XCTAssertTrue(controller.songIsDownloaded(name: k.firstSongName))
    }
    
    func test_songIsDownloaded_Returns_true(){
        XCTAssertTrue(controller.songIsDownloaded(name: "Dulce"))
    }
    
    func test_songIsDownloaded_Returns_false() {
        XCTAssertFalse(controller.songIsDownloaded(name: "TestSong"))
    }
    
    //MARK: - Table View
    func test_TableView_Number_Of_Rows() {
        controller.songs = getSongs()
        
        let count = controller.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(count, controller.songs.count + 1)
    }
    
    func test_tableView_cellForRowAtIndexPath() {
        controller.unlockedSongs = true

        controller.songs = getSongs()

        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as? SongCell
            else { XCTFail(); return }
        
        XCTAssertEqual(cell.songName, "a1")
        XCTAssertEqual(cell.songInfoLabel.text, "a1")
        XCTAssertEqual(cell.downloadLabel.text, NSLocalizedString("sideMenu-viewController.download-button.title", comment: ""))

        XCTAssertEqual(cell.artist, "Alex")
        XCTAssertEqual(cell.artistInfoLabel.text, "Alex")
        
        XCTAssertFalse(cell.songIsDownloaded)
    }

    func test_tableView_cellForRowAtIndexPath_Shows_Unlock() {
        controller.unlockedSongs = false
        controller.songs = getSongs()

        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as? SongCell
            else { XCTFail(); return }

        XCTAssertEqual(cell.songName, "a1")
        XCTAssertEqual(cell.songInfoLabel.text, "a1")
        XCTAssertEqual(cell.downloadLabel.text, NSLocalizedString("sideMenu-viewController.download-button.unlock.title", comment: ""))

        XCTAssertEqual(cell.artist, "Alex")
        XCTAssertEqual(cell.artistInfoLabel.text, "Alex")

        XCTAssertFalse(cell.songIsDownloaded)
    }
    
    func test_tableView_didSelectRowAtIndexPath_Sets_tapViewController() {
        
        let controller = SideMenuViewControllerStub()
        let _ = controller.view

        controller.songs = getSongs()
        
        let indexPath = IndexPath(row: 1, section: 0)
        controller.tableView(controller.tableView!, didSelectRowAt: indexPath)
        
        XCTAssertEqual(controller.tapViewController?.song?.name, "a2")
        XCTAssertEqual(controller.tapViewController?.song?.artist, "Imi")
    }

    func test_tableView_didSelectRowAtIndexPath_Calls_UnlockSongVC() {

        class LocalSideMenuViewControllerStub: SideMenuViewController {
            var presentUnlockSongsVCCalled = false
            override func presentUnlockSongsVC(songIndex: Int) {
                presentUnlockSongsVCCalled = true
            }
        }

        let controller = LocalSideMenuViewControllerStub()
        let _ = controller.view
        controller.unlockedSongs = false
        controller.songs = getSongs()

        let indexPath = IndexPath(row: 1, section: 0)
        controller.tableView(controller.tableView!, didSelectRowAt: indexPath)

        XCTAssertTrue(controller.presentUnlockSongsVCCalled)
    }

    
    func test_tableView_didSelectRowAtIndexPath_Calls_downloadSong() {
        
        class LocalSideMenuViewControllerStub: SideMenuViewController {
            var downloadSongCalled = false
            override func downloadSong(name: String, indexPath: IndexPath) {
                downloadSongCalled = true
            }
        }
        
        let controller = LocalSideMenuViewControllerStub()
        let _ = controller.view
        controller.unlockedSongs = true
        controller.songs = getSongs()
        
        let indexPath = IndexPath(row: 1, section: 0)
        controller.tableView(controller.tableView!, didSelectRowAt: indexPath)
        
        XCTAssertTrue(controller.downloadSongCalled)
    }
    
    func test_tableView_canEditRow_returns_false_For_First_Song() {
        controller.songs = getSongs()
        let indexPath = IndexPath(row: 0, section: 0)
        
        XCTAssertFalse(controller.tableView(controller.tableView, canEditRowAt: indexPath))
    }
    
    func test_tableView_canEditRow_returns_true() {
        controller.songs = getSongs()
        let indexPath = IndexPath(row: 1, section: 0)
        
        XCTAssertTrue(controller.tableView(controller.tableView, canEditRowAt: indexPath))
    }
    
    func test_tableVew_Cell_Height() {
        let indexPath = IndexPath(row: 0, section: 0)

        let songRowheight = controller.tableView(controller.tableView!, heightForRowAt: indexPath)
                
        XCTAssertEqual(122.0, songRowheight)
        
        let lastIndex = IndexPath(row: controller.songs.count, section: 0)
        let slidRowheight = controller.tableView(controller.tableView!, heightForRowAt: lastIndex)
        XCTAssertEqual(45.0, slidRowheight)
    }
    
    func test_preferStatusBarHidden_Set_To_true() {
        XCTAssertTrue(controller.prefersStatusBarHidden)
    }
    
    //MARK: - Buttons
    func test_onTutorialButtonPressed() {
        controller.songs = getSongs()
        
        controller.tutorialButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(controller.tapViewController?.song?.name, "a1")
        XCTAssertEqual(controller.tapViewController?.song?.artist, "Alex")
    }

    func test_onGiveFeedBackButtonPressed_presents_mailController() {
        let controller = SideMenuViewControllerStub()
        let _ = controller.view

        controller.songs = getSongs()

        controller.feedbackButton.sendActions(for: .touchUpInside)

        XCTAssertNotNil(controller.viewControllerPresented as? MFMailComposeViewController)
    }
    
    //MARK: - SongCell
    func test_SongCell() {
        controller.songs = getSongs()
        
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as? SongCell
            else { XCTFail(); return}
        
        XCTAssertNotNil(cell.coverArtImageView)
        XCTAssertNotNil(cell.songInfoLabel)
        XCTAssertNotNil(cell.artistInfoLabel)
        XCTAssertNotNil(cell.coverArtImageView)
        
        cell.songName = "song1"
        XCTAssertEqual(cell.songInfoLabel.text, "song1")
        
        cell.artist = "artist1"
        XCTAssertEqual(cell.artistInfoLabel.text, "artist1")
    }
    
    func test_SongCell_Shows_Download_Button() {
        controller.songs = getSongs()
        
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as? SongCell
            else { XCTFail(); return }
        
        cell.songIsDownloaded = false
        cell.downloadLabel.isHidden = false
    }
    
    func test_SongCell_hides_Download_Button() {
        controller.songs = getSongs()
        
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as? SongCell
            else { XCTFail(); return }
    
        cell.songIsDownloaded = true
        cell.downloadLabel.isHidden = true
    }
    
    class SideMenuViewControllerStub: SideMenuViewController {
        override  func songIsDownloaded(name: String) -> Bool {
            return true
        }

        var viewControllerPresented: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
            viewControllerPresented = viewControllerToPresent
        }
    }
    
    func getSongs() -> [Song]{
        
        let song1 = Song(name: "a1",
                        artist: "Alex",
                        artistId: 1,
                        bpm: 60,
                        songId: 5,
                        songLevel: 1,
                        songTime: 46,
                        songType: 1,
                        storeURL: "a.com")
        
        let song2 = Song(name: "a2",
                        artist: "Imi",
                        artistId: 2,
                        bpm: 130,
                        songId: 8,
                        songLevel: 2,
                        songTime: 90,
                        songType: 1,
                        storeURL: "i.com")
        
        let song3 = Song(name: "a3",
                        artist: "Oscar",
                        artistId: 3,
                        bpm: 75,
                        songId: 9,
                        songLevel: 3,
                        songTime: 59,
                        songType: 2,
                        storeURL: "o.com")
        
        return [song1, song2, song3]
    }
    
    func test_SlideLeftCell() {
        
        controller.songs = getSongs()
        
        let row = controller.songs.count
        let indexPath = IndexPath(row: row , section: 0)
        guard let cell = controller.tableView(controller.tableView, cellForRowAt: indexPath) as? SlideLeftCell
            else { XCTFail(); return}
        
        XCTAssertFalse(cell.isUserInteractionEnabled)
    }
}
