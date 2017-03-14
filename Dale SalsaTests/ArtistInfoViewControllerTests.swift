import XCTest

@testable import Dale_Salsa

class ArtistInfoViewControllerTests: XCTestCase {
    
    var controller: ArtistInfoViewController!

    override func setUp() {
        super.setUp()
        controller = ArtistInfoViewController(artistName: "Alex",
                                              currentArtistId: 100,
                                              song: "Life",
                                              storeURLString: "itunes1.com")
        _ = controller.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_imageView_Is_Connected() {
        XCTAssertNotNil(controller.imageView)
    }
    
    func test_backButton_Is_Connected() {
        XCTAssertNotNil(controller.backButton)
    }
    
    func test_loadingImageView_Is_Connected() {
        XCTAssertNotNil(controller.loadingImageView)
    }
    
    func test_nameLabelview_Is_Connected() {
        XCTAssertNotNil(controller.nameLabelView)
    }
    
    
    func test_nameLabel_Is_Connected() {
        XCTAssertNotNil(controller.nameLabel)
    }
    
    func test_bioTextView_Is_Connected() {
        XCTAssertNotNil(controller.bioTextView)
    }
    
    func test_buyButton_Is_Connected() {
        XCTAssertNotNil(controller.buyButton)
    }
    
    func test_shareButton_Is_Connected() {
        XCTAssertNotNil(controller.shareButton)
    }
    
    func test_loadingImage_Is_Set() {
        XCTAssertEqual(controller.loadingImageView.image, #imageLiteral(resourceName: "LoadingIcon"))
    }
    
    //MARK: - Init
    func test_artist_Set() {
        XCTAssertEqual(controller.artistName, "Alex")
    }
    
    func test_currentArtistId_Set() {
        XCTAssertEqual(controller.currentArtistId, 100)
    }
    
    func test_songName_Set() {
        XCTAssertEqual(controller.song, "Life")
    }
    
    func test_storeURL_Set() {
        XCTAssertEqual(controller.storeURLString, "itunes1.com")
    }
    
    //MARK: - viewDidLoad
    func test_viewDidLoad_Sets_nameLabel() {
        XCTAssertEqual(controller.nameLabel.text, controller.artistName)
    }
    
    func test_viewDidLoad_Sets_buyButtonTitle() {

        let buttonString = String(format: NSLocalizedString("artistInfo-viewController.buy-button.title",
                                                            comment: ""), controller.song)

        XCTAssertEqual(controller.buyButton.titleLabel?.text, buttonString)
    }

    func test_viewDidLoad_Sets_radiuses() {
        guard let backButton = controller.backButton else { XCTFail(); return }

        XCTAssertEqual(backButton.layer.cornerRadius, 2)
        XCTAssertTrue(backButton.clipsToBounds)
        
        guard let buyButton = controller.buyButton else { XCTFail(); return }
        
        XCTAssertEqual(buyButton.layer.cornerRadius, 2)
        XCTAssertTrue(buyButton.clipsToBounds)
        
        guard let shareButton = controller.shareButton else { XCTFail(); return }
        XCTAssertEqual(shareButton.layer.cornerRadius, 2)
        XCTAssertTrue(shareButton.clipsToBounds)
    }
    
    func test_viewDidLoad_Hides_loadingImageView() {
        XCTAssertTrue(controller.shareButton.isHidden)
    }
    
    func test_viewDidLoad_calls_getArtistInfo() {
        let controller = ArtistInfoViewControllerStub(artistName: "a", currentArtistId: 1, song: "b" ,storeURLString: "")
        _ = controller.view
        
        XCTAssertTrue(controller.getArtistInfoCalled)
    }
    
    func test_viewDidLoad_Sets_Downloaded_Image() {
        XCTAssertNotNil(controller.imageView.image)
    }
    
    func test_viewDidLoad_Downloads_Image() {
        let controller = ArtistInfoViewControllerStub(artistName: "a", currentArtistId: 1, song: "b" ,storeURLString: "")
        _ = controller.view

        XCTAssertTrue(controller.downloadImageCalled)
    }
    
    //Loading Spinner
    func test_Downloading_Image_Starts_Spinner() {        
        controller.downloadImage()
        
        XCTAssertFalse(controller.spinningIsPaused)
    }
    
    func test_Downloading_Image_Shows_LoadingIcon() {
        controller.downloadImage()
        
        XCTAssertFalse(controller.loadingImageView.isHidden)
    }
    
    func test_Downloaded_Image_Starts_Spinner() {
        controller.downloadImage()
        XCTAssertFalse(controller.spinningIsPaused)
        
        let hideExpectation = expectation(description: "AsyncHide")
        controller.hideLoadingIcon() {  hideExpectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(controller.spinningIsPaused)
    }
    
    func test_Downloaded_Image_Shows_LoadingIcon() {
        controller.downloadImage()
        XCTAssertFalse(controller.loadingImageView.isHidden)
        
        let hideExpectation = expectation(description: "AsyncHide")
        controller.hideLoadingIcon() {  hideExpectation.fulfill() }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(controller.loadingImageView.isHidden)
    }
    
    class ArtistInfoViewControllerStub : ArtistInfoViewController {
        var getArtistInfoCalled = false
        override func getArtistInfo() {
            getArtistInfoCalled = true
        }
        
        var downloadImageCalled = true
        override func downloadImage() {
            downloadImageCalled = true
        }
    }
}
