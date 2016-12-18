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


final class SimpleLabelModelTVCell:UIPBaseTableViewCell
{
    // MARK:- UIPBaseTableViewCell/UIPBaseTableViewCellProtocol


    override func update(with model:Any, delegate:Any, for indexPath:IndexPath)
    {
        // apply model to view
        let simpleLabelModel2:SimpleLabelModel2 = model as! SimpleLabelModel2

        #if os(iOS) || os(tvOS)
            self.textLabel?.text = simpleLabelModel2.mText
        #elseif os(macOS)
            self.textLabel?.text = simpleLabelModel2.mText
        #endif

        #if os(iOS) || os(tvOS)
            self.backgroundColor = UIPPlatformColor(hue:simpleLabelModel2.mBackgroundColorHue, saturation:0.5, brightness:1, alpha:1)
        #elseif os(macOS)
            self.view.layer?.backgroundColor = UIPPlatformColor(hue:simpleLabelModel2.mBackgroundColorHue, saturation:0.5, brightness:1, alpha:1).cgColor
        #endif
    }
}

