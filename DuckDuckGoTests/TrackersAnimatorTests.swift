//
//  TrackersAnimatorTests.swift
//  DuckDuckGo
//
//  Copyright © 2020 DuckDuckGo. All rights reserved.
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

class TrackersAnimatorTests: XCTestCase {
    
    var omniBar: OmniBar!
    
    static let pageUrl = "http://example.com"
    
    override func setUp() {
        super.setUp()
        
        omniBar = OmniBar.loadFromXib()
    }
    
    override func tearDown() {
        super.tearDown()
        
        omniBar = nil
    }
    
    func testWhenNoTrackersWereFoundThenThereIsNoConfigNeeded() {
        XCTAssertFalse(omniBar.trackersAnimator.configure(omniBar,
                                                          toDisplay: [],
                                                          shouldCollapse: false))
    }
    
    func testWhenOneTrackerNetworkWasFoundThenThereIsOneItemPresented() {
        let entity = Entity(displayName: "E", domains: [], prevalence: 1)
        let trackers = [DetectedRequest(url: "a",
                                        knownTracker: nil,
                                        entity: entity,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "b",
                                        knownTracker: nil,
                                        entity: entity,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl)]
        
        XCTAssert(omniBar.trackersAnimator.configure(omniBar,
                                                     toDisplay: trackers,
                                                     shouldCollapse: false))
        
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[0].isHidden)
        XCTAssert(omniBar.siteRatingContainer.trackerIcons[1].isHidden)
        XCTAssert(omniBar.siteRatingContainer.trackerIcons[2].isHidden)
    }

    func testWhenTwoTrackerNetworksWereFoundThenThereAreTwoItemsPresented() {
        let entity1 = Entity(displayName: "E1", domains: [], prevalence: 1)
        let entity2 = Entity(displayName: "E2", domains: [], prevalence: 1)
        
        let trackers = [DetectedRequest(url: "a",
                                        knownTracker: nil,
                                        entity: entity1,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "b",
                                        knownTracker: nil,
                                        entity: entity2,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl)]
        
        XCTAssert(omniBar.trackersAnimator.configure(omniBar,
                                                     toDisplay: trackers,
                                                     shouldCollapse: false))
        
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[0].isHidden)
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[1].isHidden)
        XCTAssert(omniBar.siteRatingContainer.trackerIcons[2].isHidden)
    }
    
    func testWhenThreeTrackerNetworksWereFoundThenThereAreThreeItemsPresented() {
        let entity1 = Entity(displayName: "E1", domains: [], prevalence: 1)
        let entity2 = Entity(displayName: "E2", domains: [], prevalence: 1)
        let entity3 = Entity(displayName: "E3", domains: [], prevalence: 1)
        
        let trackers = [DetectedRequest(url: "a",
                                        knownTracker: nil,
                                        entity: entity1,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "b",
                                        knownTracker: nil,
                                        entity: entity2,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "c",
                                        knownTracker: nil,
                                        entity: entity3,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl)]
        
        XCTAssert(omniBar.trackersAnimator.configure(omniBar,
                                                     toDisplay: trackers,
                                                     shouldCollapse: false))
        
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[0].isHidden)
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[1].isHidden)
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[2].isHidden)
    }
    
    func testWhenMoreThanThreeTrackerNetworksWereFoundThenThereAreThreeItemsPresented() {
        let entity1 = Entity(displayName: "E1", domains: [], prevalence: 1)
        let entity2 = Entity(displayName: "E2", domains: [], prevalence: 1)
        let entity3 = Entity(displayName: "E3", domains: [], prevalence: 1)
        let entity4 = Entity(displayName: "E4", domains: [], prevalence: 1)
        let trackers = [DetectedRequest(url: "a",
                                        knownTracker: nil,
                                        entity: entity1,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "b",
                                        knownTracker: nil,
                                        entity: entity2,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "c",
                                        knownTracker: nil,
                                        entity: entity3,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl),
                        DetectedRequest(url: "d",
                                        knownTracker: nil,
                                        entity: entity4,
                                        state: .blocked,
                                        pageUrl: TrackersAnimatorTests.pageUrl)]
        
        XCTAssert(omniBar.trackersAnimator.configure(omniBar,
                                                     toDisplay: trackers,
                                                     shouldCollapse: true))
        
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[0].isHidden)
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[1].isHidden)
        XCTAssertFalse(omniBar.siteRatingContainer.trackerIcons[2].isHidden)
    }
}
