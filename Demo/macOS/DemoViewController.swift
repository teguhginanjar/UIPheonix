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


final class DemoViewController:NSViewController,
                               NSCollectionViewDelegateFlowLayout, NSCollectionViewDataSource,
                               UIPButtonDelegate
{
    // MARK: Public IB Outlet
    @IBOutlet fileprivate weak var ibCollectionView:NSCollectionView!

    // MARK: Private Members
    fileprivate var mAppDisplayStateType:AppDisplayStateType!
    fileprivate var mUIPheonix:UIPheonix!

    // MARK: (for demo purpose only)
    fileprivate var mPersistentDisplayModels:Array<UIPBaseModelProtocol>?


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

        vc.mAppDisplayStateType = appDisplayState.typeValue

        return vc
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()

        // collection view: delegate & data source
        ibCollectionView.delegate = self
        ibCollectionView.dataSource = self

        initUIPheonix()
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


    // MARK:- UIPButtonDelegate


    func buttonAction(_ buttonId:Int)
    {
        var isTheAppendModelsDemo:Bool = false
        var isThePersistentDemo:Bool = false
        var shouldAnimateChange:Bool = true

        // set the display state depending on which button we clicked
        switch (buttonId)
        {
            case ButtonId.startUp.rawValue: mAppDisplayStateType = AppDisplayState.startUp.typeValue; break

            case ButtonId.mixed.rawValue: mAppDisplayStateType = AppDisplayState.mixed.typeValue; break

            case ButtonId.animations.rawValue: mAppDisplayStateType = AppDisplayState.animations.typeValue; break

            case ButtonId.switching.rawValue: mAppDisplayStateType = AppDisplayState.switching.typeValue; break

            case ButtonId.appending.rawValue: mAppDisplayStateType = AppDisplayState.appending.typeValue; break

                case ButtonId.appendingReload.rawValue:
                    mAppDisplayStateType = AppDisplayState.appending.typeValue
                    isTheAppendModelsDemo = true
                    shouldAnimateChange = false
                break

            case ButtonId.persistent.rawValue:
                mAppDisplayStateType = AppDisplayState.persistent.typeValue
                isThePersistentDemo = true
            break

                case ButtonId.persistentGoBack.rawValue:
                    mAppDisplayStateType = AppDisplayState.startUp.typeValue
                    // when we leave the state, store the current display models for later reuse
                    // so that when we re-enter the state, we can just use them as they were
                    mPersistentDisplayModels = mUIPheonix.displayModels()
                break

            case ButtonId.specific.rawValue: mAppDisplayStateType = AppDisplayState.specific.typeValue; break

            default: mAppDisplayStateType = AppDisplayState.startUp.typeValue; break
        }


        // update UI
        if (shouldAnimateChange)
        {
            animateView(animationState:false, completionHandler:
            {
                [weak self] in
                guard let strongSelf:DemoViewController = self else { fatalError("`self` does not exist anymore!") }

                strongSelf.updateView(isTheAppendModelsDemo:isTheAppendModelsDemo, isThePersistentDemo:isThePersistentDemo)
                strongSelf.animateView(animationState:true, completionHandler:nil)
            })
        }
        else
        {
            updateView(isTheAppendModelsDemo:isTheAppendModelsDemo, isThePersistentDemo:isThePersistentDemo)
        }
    }


    // MARK:- Private


    fileprivate func initUIPheonix()
    {
        mUIPheonix = UIPheonix(with:ibCollectionView)
    }


    fileprivate func setupWithJSON()
    {
        if let jsonDictionary:Dictionary<String, Any> = DataProvider.loadJSON(inFilePath:mAppDisplayStateType.jsonFileName.rawValue)
        {
            mUIPheonix.setModelViewRelationships(jsonDictionary[UIPConstants.Collection.modelViewRelationships] as! Dictionary<String, String>)
            mUIPheonix.setDisplayModels(jsonDictionary[UIPConstants.Collection.cellModels] as! Array<Any>, append:false)
        }
        else
        {
            fatalError("Failed to init with JSON file!")
        }
    }


    fileprivate func setupWithModels()
    {
        mUIPheonix.setModelViewRelationships([SimpleButtonModel.nameOfClass:SimpleButtonModelCVCell.nameOfClass,
                                              SimpleCounterModel.nameOfClass:SimpleCounterModelCVCell.nameOfClass,
                                              SimpleLabelModel.nameOfClass:SimpleLabelModelCVCell.nameOfClass,
                                              SimpleTextFieldModel.nameOfClass:SimpleTextFieldModelCVCell.nameOfClass,
                                              SimpleVerticalSpaceModel.nameOfClass:SimpleVerticalSpaceModelCVCell.nameOfClass,
                                              SimpleViewAnimationModel.nameOfClass:SimpleViewAnimationModelCVCell.nameOfClass])

        var models:[UIPBaseCVCellModel] = [UIPBaseCVCellModel]()

        for i in 1 ... 20
        {
            let simpleLabelModel:SimpleLabelModel = SimpleLabelModel(text:"Label \(i)",
                                                                     size:(12.0 + CGFloat(i) * 2.0),
                                                                     alignment:SimpleLabelModel.Alignment.left,
                                                                     style:SimpleLabelModel.Style.regular,
                                                                     backgroundColorHue:(CGFloat(i) * 0.05),
                                                                     notificationId:"")
            models.append(simpleLabelModel)
        }

        mUIPheonix.setDisplayModels(models)
    }


    fileprivate func updateView(isTheAppendModelsDemo:Bool=false, isThePersistentDemo:Bool=false)
    {
        if (isTheAppendModelsDemo)
        {
            // append the current display models list to itself
            mUIPheonix.addDisplayModels(mUIPheonix.displayModels())
        }
        else if (isThePersistentDemo)
        {
            if (mPersistentDisplayModels == nil) {
                setupWithJSON()
            }
            else
            {
                // set the persistent display models
                mUIPheonix!.setDisplayModels(mPersistentDisplayModels!)
            }
        }
        else
        {
            // Test any of these functions. //

            setupWithJSON()
            // or //
            //setupWithModels()
        }

        // reload the collection view
        ibCollectionView.reloadData()
    }


    fileprivate func animateView(animationState:Bool, completionHandler:(()->Void)?)
    {
        // do a nice fading animation
        NSAnimationContext.runAnimationGroup(
        {
            [weak self] (context:NSAnimationContext) in

            guard let strongSelf:DemoViewController = self else { fatalError("`self` does not exist anymore!") }

            context.duration = 0.25
            strongSelf.view.animator().alphaValue = animationState ? 1.0 : 0.0
        },
        completionHandler:completionHandler)
    }
}

