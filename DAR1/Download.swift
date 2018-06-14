//
//  Download.swift
//  DAR1
//
//  Created by Arthur Belyankov on 14.06.2018.
//  Copyright © 2018 Arthur Belyankov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Download{
    public static let instance = Download()
    
    func DownloadAudio(url: String!, namefile: String, completion: @escaping (Float) -> ()) {
        let encode = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let destination: DownloadRequest.DownloadFileDestination = {_,_  in
            var docurl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            docurl.appendPathComponent(namefile)
            return (docurl, [.removePreviousFile])
        }
        
        Alamofire.download(encode!, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                completion(Float(progress.fractionCompleted))
            }
            .responseData { response in
                if response.result.value != nil {
                }
        }
    }
    
     func DeleteSong( namefile: String) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent(namefile)
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: destinationPath) {
                try fileManager.removeItem(atPath: destinationPath)
                print("Delete Done")
            }
            else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}

