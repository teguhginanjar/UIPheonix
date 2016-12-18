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
        ibTableView.separatorColor = UIColor.white

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

        let _:UIPCellHeight = cellView.update(with:cellModel, delegate:self, for:indexPath)

        cellView.layoutIfNeeded()

        return cellView
    }


    // MARK: UITableViewDelegate


    func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath)
    -> CGFloat
    {
        let cellModel:UIPBaseCellModel = mUIPheonix.model(at:indexPath.item)!
        let cellView:UIPBaseTableViewCell = mUIPheonix.view(forReuseIdentifier:cellModel.nameOfClass)!

        // default: full width, no margins
        let defaultCellWidth:CGFloat = tableView.bounds.size.width

        let modelCellHeight:UIPCellHeight = cellView.update(with:cellModel, delegate:self, for:indexPath)
        let layoutCellHeight:CGFloat = UIPheonix.calculateLayoutHeightForCell(cellView, preferredWidth:defaultCellWidth)

        return UIPheonix.viewHeight(with:layoutCellHeight, addedHeight:modelCellHeight)
    }


    // MARK:- Private


    fileprivate func initUIPheonix()
    {
        mUIPheonix = UIPheonix(with:ibTableView)
    }


    fileprivate func setupWithModels()
    {
        mUIPheonix.setModelViewRelationships([SimpleLabelModel2.nameOfClass:SimpleLabelModelTVCell.nameOfClass])

        var models:[UIPBaseCellModel] = [UIPBaseCellModel]()

        for i in 1 ... 20
        {
            let simpleLabelModel:SimpleLabelModel2 = SimpleLabelModel2(text:"#\(i) The quick, brown fox jumps over a lazy dog.",
                                                                       backgroundColorHue:(CGFloat(i) * 0.05))
            models.append(simpleLabelModel)
        }

        mUIPheonix.setDisplayModels(models)
    }


    fileprivate func updateView()
    {
        setupWithModels()

        // reload the table view
        ibTableView.reloadData()
    }
}

