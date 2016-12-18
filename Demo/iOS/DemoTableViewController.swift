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

import UIKit


final class DemoTableViewController:UIViewController,
                                    UITableViewDelegate, UITableViewDataSource
{
    // MARK: Public IB Outlet
    @IBOutlet weak var ibTableView:UITableView!

    // MARK: Private Members
    fileprivate var mUIPheonix:UIPheonix!


    // MARK:- Life Cycle


    ///
    /// Create a new instance of self with nib.
    ///
    class func newInstance()
    -> DemoTableViewController
    {
        let vc:DemoTableViewController = self.init(nibName:"\(self)", bundle:nil)

        return vc
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupTableView()
        initUIPheonix()
        updateView()
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


    // Nothing here for now. //


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


    // MARK:- Private


    fileprivate func setupTableView()
    {
        ibTableView.delegate = self
        ibTableView.dataSource = self

        ///
        /// In this case, we are using custom table view cell types.
        /// But if we were only using the built-in table cell types – this would not be necessary, because they have fixed height of 44 points.
        ///

        // From Apple documentation:
        // You may set the row height for cells if the delegate doesn’t implement the tableView(_:heightForRowAt:) method.
        // The default value of rowHeight is UITableViewAutomaticDimension.
        // Note that if you create a self-sizing cell in Interface Builder, the default row height is changed to the value
        // set in Interface Builder. To get the expected self-sizing behavior for a cell that you create in Interface Builder,
        // you must explicitly set rowHeight equal to UITableViewAutomaticDimension in your code.
//        ibTableView.rowHeight = UITableViewAutomaticDimension

        // From Apple documentation:
        // When you create a self-sizing table view cell, you need to set this property and use constraints to define the cell’s size.
        // in this case we set the default height set in IB
//        ibTableView.estimatedRowHeight = 117
    }


    fileprivate func initUIPheonix()
    {
        mUIPheonix = UIPheonix(with:ibTableView)
    }


    fileprivate func setupWithModels()
    {
        mUIPheonix.setModelViewRelationships([SimpleLabelModel2.nameOfClass:SimpleLabelModelTVCell.nameOfClass,
                                              SimpleUserProfileModel.nameOfClass:SimpleUserProfileModelTVCell.nameOfClass])

        var models:[UIPBaseCellModel] = [UIPBaseCellModel]()

        ///
        /// Illustrate the usage of
        /// and that both self-sizing cells with constraints
        /// and the default build-in cells work just fine with auto-layout.
        ///

        models.append(SimpleLabelModel2(text:"Label #1", backgroundColorHue:0.2))
        
        let simpleUserProfileModel1:SimpleUserProfileModel = SimpleUserProfileModel(title:"#1 The quick.",
                                                                                   description:"Tilde coloring book health.")
        models.append(simpleUserProfileModel1)

        models.append(SimpleLabelModel2(text:"Label #2", backgroundColorHue:0.4))

        let simpleUserProfileModel2:SimpleUserProfileModel = SimpleUserProfileModel(title:"#2 The quick, brown fox.",
                                                                                   description:"Tilde coloring book health goth echo park, gentrify semiotics vinyl cardigan quinoa meh master cleanse cray four dollar toast.")
        models.append(simpleUserProfileModel2)

        models.append(SimpleLabelModel2(text:"Label #3", backgroundColorHue:0.6))

        let simpleUserProfileModel3:SimpleUserProfileModel = SimpleUserProfileModel(title:"#12 The quick, brown fox jumps over a lazy dog.",
                                                                                   description:"Tilde coloring book health goth echo park, gentrify semiotics vinyl cardigan quinoa meh master cleanse cray four dollar toast scenester hammock. Butcher truffaut flannel, unicorn fanny pack skateboard pug four loko.")
        models.append(simpleUserProfileModel3)

        models.append(SimpleLabelModel2(text:"Label #4", backgroundColorHue:0.8))


        mUIPheonix.setDisplayModels(models)
    }


    fileprivate func updateView()
    {
        setupWithModels()

        // reload the table view
        ibTableView.reloadData()
    }
}

