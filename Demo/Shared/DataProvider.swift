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

import Foundation


final class DataProvider
{
    ///
    /// Load JSON file.
    ///
    class func loadJSON(inFilePath filePath:String)
    -> Dictionary<String, Any>?
    {
        if let jsonFilePath:String = Bundle.main.path(forResource:filePath, ofType:"json")
        {
            do
            {
                let fileUrl:URL = URL(fileURLWithPath:jsonFilePath)
                let jsonData:Data = try Data(contentsOf:fileUrl, options:NSData.ReadingOptions.uncached)
                let jsonDictionary:Dictionary<String, Any> = try JSONSerialization.jsonObject(with:jsonData,
                                                                                              options:JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>

                return jsonDictionary
            }
            catch let error
            {
                print("DataProvider failed with: \(error.localizedDescription)")
            }
        }
        else
        {
            print("DataProvider failed with: filename/path not found at \(filePath)")
        }

        return nil
    }
}
