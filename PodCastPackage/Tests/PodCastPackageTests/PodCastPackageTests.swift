import XCTest
@testable import PodCastPackage
import Playlist
import NetworkHandling

final class PodCastPackageTests: XCTestCase {
    
    func test_getPaymentMethodsSucceeded() async {
        let playlistLoader = PlaylistLoader(
            client: .mock(.file(named: "PlayListResponse", in: .module)),
            session: .mock()
        )
        do {
            let response = try await playlistLoader.loadPlayList()
            XCTAssertNotNil(response)
        } catch {
            XCTFail("some error")
        }
    }
    
    func test_getPaymentMethodsFailed() async {
        let loaderWithFailure = PlaylistLoader(
            client: .mock(.file(named: "errorResponse", in: .module)),
            session: .mock()
        )
        do {
           _ = try await loaderWithFailure.loadPlayList()
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
   
    
}
