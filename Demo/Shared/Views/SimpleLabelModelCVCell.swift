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


final class SimpleLabelModelCVCell:UIPBaseCVCellView
{
    // MARK: Private IB Outlet
    @IBOutlet fileprivate weak var ibLabel:UIPPlatformLabel!


    // MARK: Private Member
    fileprivate var mNotificationId:String?


    // MARK:- UICollectionViewCell


    override func prepareForReuse()
    {
        super.prepareForReuse()

        // uninstall notification
        toggleNotification(state:false)
    }


    // MARK:- UIPBaseCVCellView/UIPBaseCVCellProtocol


    override class func nibNameStatic()
    -> String
    {
        return "\(self)"
    }


    override func update(with model:Any, delegate:Any, for indexPath:IndexPath)
    -> UIPCellSize
    {
        // apply model to view
        let simpleLabelModel:SimpleLabelModel = model as! SimpleLabelModel

        #if os(iOS) || os(tvOS)
            ibLabel.text = simpleLabelModel.mText
            ibLabel.textAlignment = textAligment(with:simpleLabelModel.mAlignment)
        #elseif os(macOS)
            ibLabel.stringValue = simpleLabelModel.mText
            ibLabel.alignment = textAligment(with:simpleLabelModel.mAlignment)
        #endif

        ibLabel.font = fontStyle(with:simpleLabelModel.mStyle, size:simpleLabelModel.mSize)

        #if os(iOS) || os(tvOS)
            self.backgroundColor = UIPPlatformColor(hue:simpleLabelModel.mBackgroundColorHue, saturation:0.5, brightness:1, alpha:1)
        #elseif os(macOS)
            self.view.layer?.backgroundColor = UIPPlatformColor(hue:simpleLabelModel.mBackgroundColorHue, saturation:0.5, brightness:1, alpha:1).cgColor
        #endif

        // install notification
        if (simpleLabelModel.mNotificationId != nil)
        {
            // store notification id for later
            mNotificationId = simpleLabelModel.mNotificationId

            toggleNotification(state:true)
        }

        // layer drawing
        #if os(iOS) || os(tvOS)
            self.layer.cornerRadius = CGFloat.valueForPlatform(mac:5, mobile:5, tv:20)
        #elseif os(macOS)
            self.view.layer?.cornerRadius = CGFloat.valueForPlatform(mac:5, mobile:5, tv:20)
        #endif

        // return view size
        return UIPCellSize(absoluteWidth:false, width:-20,
                           absoluteHeight:false, height:0)
    }


    // MARK:- Private


    fileprivate func toggleNotification(state:Bool)
    {
        guard (mNotificationId != nil) else { return }

        if (state)
        {
            NotificationCenter.default.addObserver(self, selector:#selector(handleNotification),
                                                   name:NSNotification.Name(mNotificationId!), object:nil)
        }
        else {
            NotificationCenter.default.removeObserver(self, name:NSNotification.Name(mNotificationId!), object:nil)
        }
    }


    @objc fileprivate func handleNotification(notification:NSNotification)
    {
        let value:Double = notification.userInfo?["CounterValue"] as? Double ?? Double.nan

        #if os(iOS) || os(tvOS)
            ibLabel.text = "The counter value is: \(Int(value))"
        #elseif os(macOS)
            ibLabel.stringValue = "The counter value is: \(Int(value))"
        #endif
    }


    fileprivate func textAligment(with aligment:String)
    -> NSTextAlignment
    {
        switch (aligment)
        {
            case "left":
                return NSTextAlignment.left

            case "center":
                return NSTextAlignment.center

            case "right":
                return NSTextAlignment.right

            default:
                return NSTextAlignment.left
        }
    }


    fileprivate func fontStyle(with style:String, size:CGFloat)
    -> UIPPlatformFont
    {
        switch (style)
        {
            case "regular":
                return UIPPlatformFont.systemFont(ofSize:size)

            case "bold":
                return UIPPlatformFont.boldSystemFont(ofSize:size)

            default:
                return UIPPlatformFont.systemFont(ofSize:size)
        }
    }
}

