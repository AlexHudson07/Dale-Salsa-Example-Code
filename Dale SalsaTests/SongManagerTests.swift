import XCTest
@testable import Dale_Salsa

class SongManagerTests: XCTestCase {
    
    let manager = SongManager.sharedInstance
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_SongMangager_Is_Instantiated() {
        XCTAssertNotNil(manager)
    }
}
