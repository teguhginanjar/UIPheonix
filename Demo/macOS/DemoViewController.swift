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

import Cocoa


final class DemoViewController:NSViewController, NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource,
                               UIPDelegate, UIPButtonDelegate
{
    // MARK: Public IB Outlet
    @IBOutlet weak var ibCollectionView:NSCollectionView!

    // MARK: Private Members
    fileprivate var mUIPheonix:UIPheonix!
    fileprivate var mCurrentDisplayState:AppDisplayState!

    // MARK: (for demo purpose only)
    fileprivate var mExamplePersistentDisplayList:Array<UIPBaseModelProtocol>?
    fileprivate var mAnimateViewReload:Bool = true


    // MARK:- Life Cycle


    ///
    /// Create a new instance of self with nib.
    ///
    class func newInstance(with appDisplayState:AppDisplayState)
    -> DemoViewController
    {
        guard let vc:DemoViewController = self.init(nibName:"\(self)", bundle:nil) else {
            fatalError("[UIPheonix] Could not create new instance of `DemoViewController` from nib!")
        }

        vc.mCurrentDisplayState = appDisplayState

        return vc
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()

        // delegate & data source
        ibCollectionView.delegate = self
        ibCollectionView.dataSource = self

        updateView()
    }


    // MARK:- NSCollectionViewDataSource


    func collectionView(_ collectionView:NSCollectionView, numberOfItemsInSection section:Int)
    -> Int
    {
        return mUIPheonix.count()
    }


    func collectionView(_ collectionView:NSCollectionView, itemForRepresentedObjectAt indexPath:IndexPath)
    -> NSCollectionViewItem
    {
        let cellModel:UIPBaseCVCellModel = mUIPheonix.model(at:indexPath.item)!
        let cellView:UIPBaseCVCellView = mUIPheonix.view(withReuseIdentifier:cellModel.nameOfClass, for:indexPath)!

        let _:UIPCellSize = cellView.update(with:cellModel, delegate:self, for:indexPath)

        return cellView
    }


    // MARK:- NSCollectionViewDelegate


    func collectionView(_ collectionView:NSCollectionView, layout collectionViewLayout:NSCollectionViewLayout, insetForSectionAt section:Int)
    -> EdgeInsets
    {
        return EdgeInsets(top:10, left:0, bottom:0, right:0)
    }


    func collectionView(_ collectionView:NSCollectionView, layout collectionViewLayout:NSCollectionViewLayout, minimumLineSpacingForSectionAt section:Int)
    -> CGFloat
    {
        return 10
    }


    func collectionView(_ collectionView:NSCollectionView, layout collectionViewLayout:NSCollectionViewLayout, sizeForItemAt indexPath:IndexPath)
    -> CGSize
    {
        let cellModel:UIPBaseCVCellModel = mUIPheonix.model(at:indexPath.item)!
        let cellView:UIPBaseCVCellView = mUIPheonix.view(forReuseIdentifier:cellModel.nameOfClass)!

        // default: full width, no margins
        let defaultCellWidth:CGFloat = collectionView.bounds.size.width - 0 - 0

        let modelCellSize:UIPCellSize = cellView.update(with:cellModel, delegate:self, for:indexPath)
        let layoutCellSize:CGSize = UIPheonix.calculateLayoutSizeForCell(cellView, preferredWidth:defaultCellWidth)

        return UIPheonix.viewSize(with:layoutCellSize, addedSize:modelCellSize)
    }


    // MARK:- UIPDelegate


    func displayListDidSet()
    {
        if (mAnimateViewReload)
        {
            // Do some nice fading animation when the display-list is changed. //

            NSAnimationContext.runAnimationGroup(
            {
                [weak self] (context:NSAnimationContext) in

                context.duration = 0.5

                self?.view.animator().alphaValue = 0.0
            },
            completionHandler:
            {
                [weak self] in

                // reload
                self?.ibCollectionView.reloadData()

                NSAnimationContext.runAnimationGroup(
                {
                    [weak self] (context:NSAnimationContext) in

                    context.duration = 0.5

                    self?.view.animator().alphaValue = 1.0
                },
                completionHandler:nil)
            })
        }
        else
        {
            // just reload
            self.ibCollectionView.reloadData()
        }
    }


    // MARK:- UIPButtonDelegate


    func buttonAction(_ buttonId:Int)
    {
        // reset view animation state
        mAnimateViewReload = true

        var appendElements:Bool = false
        var isThePersistentDemo:Bool = false

        switch (buttonId)
        {
            case 0:
                mCurrentDisplayState = AppDisplayState.startUp
            break

            case 100:
                mCurrentDisplayState = AppDisplayState.mixed
            break

            case 101:
                mCurrentDisplayState = AppDisplayState.animations
            break

            case 102:
                mCurrentDisplayState = AppDisplayState.switching
            break

            case 1030:
                mCurrentDisplayState = AppDisplayState.appending
            break

                case 1031:
                    mCurrentDisplayState = AppDisplayState.appending
                    appendElements = true

                    // set view animation state
                    mAnimateViewReload = false
                break

            case 1040:
                mCurrentDisplayState = AppDisplayState.persistent
                isThePersistentDemo = true
            break

                case 1041:
                    mCurrentDisplayState = AppDisplayState.startUp
                    // when we leave the state
                    // store the current display list for later reuse
                    // so that when we re-enter the state, we can just use the stored display list
                    mExamplePersistentDisplayList = mUIPheonix.displayList()
                break

            case 105:
                mCurrentDisplayState = AppDisplayState.specific
            break

            default:
                mCurrentDisplayState = AppDisplayState.startUp
            break
        }

        updateView(appendElements:appendElements, isThePersistentDemo:isThePersistentDemo)
    }


    // MARK:- Private


    func updateView(appendElements:Bool=false, isThePersistentDemo:Bool=false)
    {
        // for the persistent demo
        if (isThePersistentDemo && (mExamplePersistentDisplayList != nil))
        {
            // update UIPheonix with the persistent display list
            mUIPheonix!.setDisplayList(with:mExamplePersistentDisplayList!)
            return
        }

        if (mUIPheonix == nil)
        {
            // init UIPheonix, with JSON file
            let jsonFileName:String = mCurrentDisplayState.rawValue
            mUIPheonix = UIPheonix(with:self, for:ibCollectionView, using:jsonFileName)
            mUIPheonix.setDisplayList(with:displayDictionary, appendElements:false)

            // or //

            // init UIPheonix, with model:view dictionary
            /*mUIPheonix = UIPheonix(with:self,
                                    for:ibCollectionView,
                                  using:[SimpleButtonModel.nameOfClass:SimpleButtonModelCVCell.nameOfClass,
                                         SimpleCounterModel.nameOfClass:SimpleCounterModelCVCell.nameOfClass,
                                         SimpleLabelModel.nameOfClass:SimpleLabelModelCVCell.nameOfClass,
                                         SimpleTextFieldModel.nameOfClass:SimpleTextFieldModelCVCell.nameOfClass,
                                         SimpleVerticalSpaceModel.nameOfClass:SimpleVerticalSpaceModelCVCell.nameOfClass,
                                         SimpleViewAnimationModel.nameOfClass:SimpleViewAnimationModelCVCell.nameOfClass])

            var modelsArray:[UIPBaseCVCellModel] = [UIPBaseCVCellModel]()

            for i in 1 ... 20
            {
                let newModel:SimpleLabelModel = SimpleLabelModel(text:"Label \(i)", size:(12.0 + CGFloat(i) * 2.0),
                                                                 alignment:"left", style:"regular",
                                                                 backgroundColorHue:(CGFloat(i) * 0.05), notificationId:"")
                modelsArray.append(newModel)
            }

            mUIPheonix.setDisplayList(with:modelsArray)*/
        }
        else
        {
            // update UIPheonix
            mUIPheonix.setDisplayList(with:displayDictionary, appendElements:appendElements)
        }
    }
}

