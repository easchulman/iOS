//
//  SiteRatingView.swift
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

import UIKit
import Core
import BrowserServicesKit

public class SiteRatingView: UIView {
    
    enum DisplayMode {
        case loading
        case ready
    }

    static let gradeImages: [Grade.Grading: UIImage] = [
        .a: #imageLiteral(resourceName: "PP Indicator Grade A"),
        .bPlus: #imageLiteral(resourceName: "PP Indicator Grade B Plus"),
        .b: #imageLiteral(resourceName: "PP Indicator Grade B"),
        .cPlus: #imageLiteral(resourceName: "PP Indicator Grade C Plus"),
        .c: #imageLiteral(resourceName: "PP Indicator Grade C"),
        .d: #imageLiteral(resourceName: "PP Indicator Grade D"),
        .dMinus: #imageLiteral(resourceName: "PP Indicator Grade D")
    ]

    @IBOutlet weak var circleIndicator: UIImageView!

    private var siteRating: SiteRating?
    var mode: DisplayMode = .loading

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = Bundle.main.loadNibNamed("SiteRatingView", owner: self, options: nil)![0] as? UIView else {
            fatalError("Failed to load view SiteRatingView")
        }
        self.addSubview(view)
        view.frame = self.bounds
        
        addInteraction(UIPointerInteraction(delegate: self))
    }

    public func update(siteRating: SiteRating?, with config: PrivacyConfiguration?) {
        self.siteRating = siteRating
        refresh(with: config)
    }
    
    private func resetSiteRatingImage() {
        circleIndicator.image = PrivacyProtectionIconSource.iconImageTemplate(withString: " ",
                                                                              iconSize: circleIndicator.bounds.size)
    }

    public func refresh(with config: PrivacyConfiguration?) {
        guard let config = config,
            let siteRating = siteRating else {
            resetSiteRatingImage()
            return
        }
        
        if AppUrls().isDuckDuckGoSearch(url: siteRating.url) {
            circleIndicator.image = UIImage(named: "LogoIcon")
            return
        }
        
        switch mode {
        case .loading:
            circleIndicator.image = PrivacyProtectionIconSource.iconImageTemplate(withString: " ",
                                                                                  iconSize: circleIndicator.bounds.size)
        case .ready:
            let grades = siteRating.scores
            let grade = config.isProtected(domain: siteRating.domain) ? grades.enhanced : grades.site
            
            circleIndicator.image = SiteRatingView.gradeImages[grade.grade]
            circleIndicator.accessibilityLabel = UserText.privacyGrade(grade.grade.rawValue.uppercased())
            circleIndicator.accessibilityHint = UserText.privacyGradeHint
        }
    }
}

extension SiteRatingView: UIPointerInteractionDelegate {
    
    public func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        return .init(effect: .lift(.init(view: self)))
    }
    
}
