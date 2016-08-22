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


class ViewController:UIViewController
{
    override func viewDidAppear(_ animated:Bool)
    {
        super.viewDidAppear(animated)

        // start the UIPheonix tvOS demo
        // create & present a new instance of the demo VC
        let demoViewController:DemoViewController = DemoViewController.newInstance(with:UIDisplayState.startUp)
        self.navigationController!.present(demoViewController, animated:true, completion:nil)
    }
}

