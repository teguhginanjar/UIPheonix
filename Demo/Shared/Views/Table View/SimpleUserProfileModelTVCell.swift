//
//  UIPheonix
//  Copyright © 2016 Mohsan Khan. All rights reserved.
//

//
//  https://github.com/MKGitHub/UIPheonix
//  http://www.xybernic.com
//  http://www.khanofsweden.com
//

//
//  Copyright 2016 Mohsan Khan
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

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif


final class SimpleUserProfileModelTVCell:UIPBaseTableViewCell
{
    // MARK: Private IB Outlets
    @IBOutlet fileprivate weak var ibTitleLabel:UIPPlatformLabel!
    @IBOutlet fileprivate weak var ibDescriptionLabel:UIPPlatformLabel!


    // MARK:- UIPBaseTableViewCell/UIPBaseTableViewCellProtocol


    #if os(iOS)
        override var rowHeight:CGFloat { get { return UITableViewAutomaticDimension } }
        override var estimatedRowHeight:CGFloat { get { return 117 } }    // return default IB design height
    #elseif os(tvOS)
        override var rowHeight:CGFloat { get { return UITableViewAutomaticDimension } }
        override var estimatedRowHeight:CGFloat { get { return 216 } }    // return default IB design height
    #elseif os(macOS)
        override var rowHeight:CGFloat { get { return 120 } }
        override var estimatedRowHeight:CGFloat { get { return 120 } }    // return default IB design height
    #endif


    override func update(with model:Any, delegate:Any, for indexPath:IndexPath)
    {
        // apply model to view
        let simpleUserProfileModel:SimpleUserProfileModel = model as! SimpleUserProfileModel

        #if os(iOS) || os(tvOS)
            ibTitleLabel.text = simpleUserProfileModel.mTitle
            ibDescriptionLabel.text = simpleUserProfileModel.mDescription
        #elseif os(macOS)
            ibTitleLabel.stringValue = simpleUserProfileModel.mTitle
            ibDescriptionLabel.stringValue = simpleUserProfileModel.mDescription
        #endif
    }
}

