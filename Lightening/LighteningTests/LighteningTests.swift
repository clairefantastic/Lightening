//
//  LighteningTests.swift
//  LighteningTests
//
//  Created by claire on 2022/5/19.
//

import XCTest
@testable import Lightening

class LighteningTests: XCTestCase {
    var sut: AVPlayerHandler!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = AVPlayerHandler()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetAudioLength() {
        // 1. given
//        let avPlayerItem = sut.setPlayer(urlString: "https://firebasestorage.googleapis.com/v0/b/lightening-626ce.appspot.com/o/message_voice%2FB51ED7F6-F5BF-4B21-9B50-7610D86BF5B
//        1.m4a?alt=media&token=9a78cdac-eda3-46a4-8d50-8a68fb8c9971")
//
//        // 2. when
//        sut.getAudioLengthTest(avPlayerItem: avPlayerItem)
//
//        // 3. then
//        XCTAssertEqual(sut.duration, 12, "Audio length is wrong")
    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
