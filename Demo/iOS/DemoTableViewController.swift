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

        // table view: delegate & data source
        ibTableView.delegate = self
        ibTableView.dataSource = self

        // when you set the rowHeight as UITableViewAutomaticDimension,
        // the table view knows to use the auto layout constraints to determine each cell’s height
        ibTableView.rowHeight = UITableViewAutomaticDimension

        // in order for the table view to do this, you must also provide an estimatedRowHeight
        // in this case just an arbitrary value (design value)
        ibTableView.estimatedRowHeight = 117

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


    // MARK:- Private


    fileprivate func initUIPheonix()
    {
        mUIPheonix = UIPheonix(with:ibTableView)
    }


    fileprivate func setupWithModels()
    {
        mUIPheonix.setModelViewRelationships([SimpleUserProfileModel.nameOfClass:SimpleUserProfileModelTVCell.nameOfClass])

        var models:[UIPBaseCellModel] = [UIPBaseCellModel]()


        let simpleUserProfileModel1:SimpleUserProfileModel = SimpleUserProfileModel(title:"#1 The quick.",
                                                                                   description:"Tilde coloring book health.")
        models.append(simpleUserProfileModel1)

        let simpleUserProfileModel2:SimpleUserProfileModel = SimpleUserProfileModel(title:"#2 The quick, brown fox.",
                                                                                   description:"Tilde coloring book health goth echo park, gentrify semiotics vinyl cardigan quinoa meh master cleanse cray four dollar toast.")
        models.append(simpleUserProfileModel2)

        let simpleUserProfileModel3:SimpleUserProfileModel = SimpleUserProfileModel(title:"#12 The quick, brown fox jumps over a lazy dog.",
                                                                                   description:"Tilde coloring book health goth echo park, gentrify semiotics vinyl cardigan quinoa meh master cleanse cray four dollar toast scenester hammock. Butcher truffaut flannel, unicorn fanny pack skateboard pug four loko.")
        models.append(simpleUserProfileModel3)


        mUIPheonix.setDisplayModels(models)
    }


    fileprivate func updateView()
    {
        setupWithModels()

        // reload the table view
        ibTableView.reloadData()
    }
}

