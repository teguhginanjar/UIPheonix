//
//  UIPheonix
//  Copyright © 2016/2017 Mohsan Khan. All rights reserved.
//

//
//  https://github.com/MKGitHub/UIPheonix
//  http://www.xybernic.com
//  http://www.khanofsweden.com
//

//
//  Copyright 2016/2017 Mohsan Khan
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

import UIKit


final class DemoTableViewController:UIPBaseViewController, UIPBaseViewControllerProtocol, UIPButtonDelegate,
                                    UITableViewDataSource, UITableViewDelegate
{
    // MARK: Public IB Outlet
    @IBOutlet fileprivate weak var ibTableView:UITableView!

    // MARK: Private Members
    fileprivate var mUIPheonix:UIPheonix!


    // MARK:- UIPBaseViewController/UIPBaseViewControllerProtocol


    ///
    /// Create a new instance of self with nib.
    ///
    static func newInstance<T:UIPBaseViewControllerProtocol>(with attributes:Dictionary<String, Any>)
    -> T
    {
        let vc:DemoTableViewController = DemoTableViewController.init(nibName:"\(self)", bundle:nil)

        // init member
        vc.mPreparedAttributes = attributes

        return vc as! T
    }


    // MARK:- Life Cycle


    override func viewDidLoad()
    {
        super.viewDidLoad()

        initUIPheonix()
        setupWithModels()
        setupTableView()
    }


    // MARK:- UITableViewDataSource


    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)
    -> Int
    {
        return mUIPheonix.count()
    }


    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath)
    -> UITableViewCell
    {
        let cellModel:UIPBaseCellModel = mUIPheonix.model(at:indexPath.item)!
        let cellView:UIPBaseTableViewCell = mUIPheonix.dequeueView(withReuseIdentifier:cellModel.nameOfClass, for:indexPath)!

        cellView.update(with:cellModel, delegate:self, for:indexPath)

        return cellView
    }


    // MARK: UITableViewDelegate


    func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)
    -> CGFloat
    {
        let cellModel:UIPBaseCellModel = mUIPheonix.model(at:indexPath.item)!
        let cellView:UIPBaseTableViewCell = mUIPheonix.view(forReuseIdentifier:cellModel.nameOfClass)!

        return cellView.rowHeight
    }


    func tableView(_ tableView:UITableView, estimatedHeightForRowAt indexPath:IndexPath)
    -> CGFloat
    {
        let cellModel:UIPBaseCellModel = mUIPheonix.model(at:indexPath.item)!
        let cellView:UIPBaseTableViewCell = mUIPheonix.view(forReuseIdentifier:cellModel.nameOfClass)!

        return cellView.estimatedRowHeight
    }


    // MARK:- UIPButtonDelegate


    func buttonAction(_ buttonId:Int)
    {
        switch (buttonId)
        {
            case ButtonId.helloWorld.rawValue:
                print("Hello World!")
            break

            default:
                fatalError("DemoTableViewController buttonAction: Unknown button id \(buttonId)!")
            break
        }
    }


    // MARK:- Private


    fileprivate func initUIPheonix()
    {
        mUIPheonix = UIPheonix(with:ibTableView)
    }


    fileprivate func setupWithModels()
    {
        mUIPheonix.setModelViewRelationships([SimpleButtonModel.nameOfClass:SimpleButtonModelTVCell.nameOfClass,
                                              SimpleLabelModel2.nameOfClass:SimpleLabelModelTVCell.nameOfClass,
                                              SimpleUserProfileModel.nameOfClass:SimpleUserProfileModelTVCell.nameOfClass])

        var models:[UIPBaseCellModel] = [UIPBaseCellModel]()

        ///
        /// Illustrate the usage of
        /// and that both self-sizing cells with constraints
        /// and the default build-in cells work just fine with auto-layout.
        ///

        models.append(SimpleButtonModel(id:ButtonId.helloWorld.rawValue, title:"Hello World!", focus:true))

        models.append(SimpleLabelModel2(text:"Label #1", backgroundColorHue:0.2))
        models.append(SimpleLabelModel2(text:"Label #2", backgroundColorHue:0.4))

        let simpleUserProfileModel1:SimpleUserProfileModel = SimpleUserProfileModel(title:"#1 The quick, brown fox.", description:"Tilde coloring book health goth echo park, gentrify semiotics vinyl cardigan quinoa meh master cleanse cray four dollar toast.")
        models.append(simpleUserProfileModel1)

        let simpleUserProfileModel2:SimpleUserProfileModel = SimpleUserProfileModel(title:"#2 The quick, brown fox jumps over a lazy dog.", description:"Tilde coloring book health goth echo park, gentrify semiotics vinyl cardigan quinoa meh master cleanse cray four dollar toast scenester hammock. Butcher truffaut flannel, unicorn fanny pack skateboard pug four loko.")
        models.append(simpleUserProfileModel2)

        models.append(SimpleButtonModel(id:ButtonId.helloWorld.rawValue, title:"Good Bye World!", focus:false))

        mUIPheonix.setDisplayModels(models)
    }


    fileprivate func setupTableView()
    {
        ibTableView.delegate = self
        ibTableView.dataSource = self

        ///
        /// In our demo, we are using custom table view cell types.
        /// But if we were only using the built-in table cell types – this would be enough, because they all have a fixed height of 66 points.
        ///

        // From Apple documentation:
        // You may set the row height for cells if the delegate doesn’t implement the tableView(_:heightForRowAt:) method.
        // The default value of rowHeight is UITableViewAutomaticDimension.
        // Note that if you create a self-sizing cell in Interface Builder, the default row height is changed to the value
        // set in Interface Builder. To get the expected self-sizing behavior for a cell that you create in Interface Builder,
        // you must explicitly set rowHeight equal to UITableViewAutomaticDimension in your code.
        ////ibTableView.rowHeight = UITableViewAutomaticDimension

        // From Apple documentation:
        // When you create a self-sizing table view cell, you need to set this property and use constraints to define the cell’s size.
        // in this case we set the default height set in IB
        ////ibTableView.estimatedRowHeight = 216
    }
}

