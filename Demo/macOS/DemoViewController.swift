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
    @IBOutlet weak var ibCollectionView:NSCollectionView!

    // MARK: Private Members
    fileprivate var mAppDisplayStateType:AppDisplayStateType!
    fileprivate var mUIPheonix:UIPheonix!

    // MARK: (for demo purpose only)
    fileprivate var mExamplePersistentDisplayList:Array<UIPBaseModelProtocol>?


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


    // MARK:- UIPButtonDelegate


    func buttonAction(_ buttonId:Int)
    {
        var appendElements:Bool = false
        var isThePersistentDemo:Bool = false
        var animateChange:Bool = true

        switch (buttonId)
        {
            case ButtonId.startUp.rawValue: mAppDisplayStateType = AppDisplayState.startUp.typeValue; break

            case 100: mAppDisplayStateType = AppDisplayState.mixed.typeValue; break

            case 101: mAppDisplayStateType = AppDisplayState.animations.typeValue; break

            case 102: mAppDisplayStateType = AppDisplayState.switching.typeValue; break

            case 1030: mAppDisplayStateType = AppDisplayState.appending.typeValue; break

                case 1031:
                    mAppDisplayStateType = AppDisplayState.appending.typeValue
                    appendElements = true
                    animateChange = false
                break

            case 1040:
                mAppDisplayStateType = AppDisplayState.persistent.typeValue
                isThePersistentDemo = true
            break

                case 1041:
                    mAppDisplayStateType = AppDisplayState.startUp.typeValue
                    // when we leave the state
                    // store the current display list for later reuse
                    // so that when we re-enter the state, we can just use the stored display list
                    mExamplePersistentDisplayList = mUIPheonix.displayModels()
                break

            case 105: mAppDisplayStateType = AppDisplayState.specific.typeValue; break

            default: mAppDisplayStateType = AppDisplayState.startUp.typeValue; break
        }


        animateView(animate:animateChange, animationState:false)
        updateView(appendElements:appendElements, isThePersistentDemo:isThePersistentDemo)
        animateView(animate:animateChange, animationState:true)
    }


    // MARK:- Private


    func updateView(appendElements:Bool=false, isThePersistentDemo:Bool=false)
    {
        // for the persistent demo
        if (isThePersistentDemo && (mExamplePersistentDisplayList != nil))
        {
            // update UIPheonix with the persistent display list
            mUIPheonix!.setDisplayModels(with:mExamplePersistentDisplayList!)
        }
        else if (appendElements)
        {
            mUIPheonix.addDisplayModels(in:mUIPheonix.displayModels())
        }
        else if (mUIPheonix == nil)
        {
            // init UIPheonix, with JSON file
            mUIPheonix = UIPheonix(with:ibCollectionView)
            if let jsonDictionary:Dictionary<String, Any> = DataProvider.loadJSON(inFilePath:mAppDisplayStateType.jsonFileName.rawValue)
            {
                mUIPheonix.setModelViewRelationships(with:jsonDictionary[UIPConstants.Collection.modelViewRelationships] as! Dictionary<String, String>)
                mUIPheonix.setDisplayModels(with:jsonDictionary[UIPConstants.Collection.cellModels] as! Array<Any>, append:false)
            }
            else {
                fatalError("Failed to init with JSON file!")
            }

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


        // reload the collection view
        ibCollectionView.reloadData()
    }


    func animateView(animate:Bool, animationState:Bool)
    {
        // do a nice fading animation
        if (animate)
        {
            NSAnimationContext.runAnimationGroup(
            {
                [weak self] (context:NSAnimationContext) in

                // guard self here…

                context.duration = 0.5
                self?.view.animator().alphaValue = animationState ? 1.0 : 0.0
            },
            completionHandler:nil)
        }
        else
        {
            view.alphaValue = animationState ? 1.0 : 0.0
        }
    }
}

