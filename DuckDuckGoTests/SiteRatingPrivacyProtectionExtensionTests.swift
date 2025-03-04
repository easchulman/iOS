//
//  SiteRatingPrivacyProtectionExtensionTests.swift
//  DuckDuckGo
//
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import XCTest
import TrackerRadarKit
import BrowserServicesKit
@testable import Core
@testable import DuckDuckGo

class SiteRatingPrivacyProtectionExtensionTests: XCTestCase {

    struct Constants {

        static let pageURL = URL(string: "https://example.com")!
        // static let majorTracker = DisconnectMeTracker(url: Constants.pageURL.absoluteString, networkName: "major")

    }

    func testMultipleMajorNetworksBlockedReturnsPluralText() {
        let rating = SiteRating(url: Constants.pageURL)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .blocked,
                                               pageUrl: Constants.pageURL.absoluteString))
        rating.trackerDetected(DetectedRequest(url: "otherurl",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .blocked,
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.majorNetworksBlockedText().contains("Trackers Blocked"))
    }

    func testMultipleMajorNetworksDetectedReturnsPluralText() {
        let rating = SiteRating(url: Constants.pageURL)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .allowed(reason: .ruleException),
                                               pageUrl: Constants.pageURL.absoluteString))
        rating.trackerDetected(DetectedRequest(url: "otherurl",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .allowed(reason: .ruleException),
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.majorNetworksDetectedText().contains("Trackers Found"))
    }

    func testMultipleNetworksBlockedReturnsPluralText() {
        let rating = SiteRating(url: Constants.pageURL)
        rating.trackerDetected(DetectedRequest(url: "someurl.com",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .blocked,
                                               pageUrl: Constants.pageURL.absoluteString))
        rating.trackerDetected(DetectedRequest(url: "otherurl.com",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .blocked,
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.networksBlockedText().contains("Trackers Blocked"))
    }

    func testMultipleNetworksDetectedReturnsPluralText() {
        let rating = SiteRating(url: Constants.pageURL)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .allowed(reason: .ruleException),
                                               pageUrl: Constants.pageURL.absoluteString))
        rating.trackerDetected(DetectedRequest(url: "otherurl",
                                               knownTracker: nil,
                                               entity: nil,
                                               state: .allowed(reason: .ruleException),
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.networksDetectedText().contains("Trackers Found"))
    }

    func testSingleMajorNetworkBlockedReturnsSinglularText() {
        let rating = SiteRating(url: Constants.pageURL)
        let entity = Entity(displayName: "Entity", domains: nil, prevalence: 100)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: entity,
                                               state: .blocked,
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.majorNetworksBlockedText().contains("Tracker Blocked"))
    }

    func testSingleMajorNetworkDetectedReturnsSinglularText() {
        let rating = SiteRating(url: Constants.pageURL)
        let entity = Entity(displayName: "Entity", domains: nil, prevalence: 100)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: entity,
                                               state: .allowed(reason: .ruleException),
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.majorNetworksDetectedText().contains("Tracker Found"))
    }

    func testSingleNetworkBlockedReturnsSinglularText() {
        let rating = SiteRating(url: Constants.pageURL)
        let entity = Entity(displayName: "Entity", domains: nil, prevalence: nil)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: entity,
                                               state: .blocked,
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.networksBlockedText().contains("Tracker Blocked"))
    }

    func testSingleNetworkDetectedReturnsSinglularText() {
        let rating = SiteRating(url: Constants.pageURL)
        let entity = Entity(displayName: "Entity", domains: nil, prevalence: nil)
        rating.trackerDetected(DetectedRequest(url: "someurl",
                                               knownTracker: nil,
                                               entity: entity,
                                               state: .allowed(reason: .ruleException),
                                               pageUrl: Constants.pageURL.absoluteString))
        XCTAssertTrue(rating.networksDetectedText().contains("Tracker Found"))
    }

}

private class MockTermsOfServiceStore: TermsOfServiceStore {

    var terms = [String: TermsOfService]()

}
