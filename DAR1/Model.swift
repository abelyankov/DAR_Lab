//
//  Model.swift
//  DAR1
//
//  Created by Arthur Belyankov on 12.06.2018.
//  Copyright © 2018 Arthur Belyankov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Model {
    var author: String!
    var title: String!
    var url: String!
    
    init(author: String, title: String, url: String) {
        self.author = author
        self.title = title
        self.url = url
    }
    static func Categories(completionHandler: @escaping ([Model]) -> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let URL = "https://vibze.github.io/downloadr-task/tracks.json"
        
        var categories = [Model]()
        
        Alamofire.request(URL, method: .get).validate().responseJSON { (response) in
            if let value = response.result.value {
                let json = JSON(value)
                for result in json["tracks"].arrayValue {
                    let author = result["artist"].stringValue
                    let song = result["title"].stringValue
                    let url = result["url"].stringValue
                    print(json)
                    let category = Model(author: author, title: song, url:url )
                    categories.append(category)
                }
                completionHandler(categories)
            }
        }
    }
}
