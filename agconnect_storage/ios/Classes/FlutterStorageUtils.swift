/*
 * Copyright 2021-2023. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import AGConnectStorage


class FlutterStorageUtils {
    
    // MARK: Static Helper Functions
    
    static func getResultList(agcStorageList: AGCStorageListResult) -> Dictionary<String, Any> {
        var map = Dictionary<String, Any>()
        var fileList = Array<String>()
        var dirList = Array<String>()
        
        for file in agcStorageList.fileList {
            fileList.append(file.path)
        }
        for dir in agcStorageList.dirList {
            dirList.append(dir.path)
        }
        
        map["dirList"] = dirList
        map["fileList"] = fileList
        map["pageMarker"] = agcStorageList.pageMarker
        
        return map
    }
    
    static func fileMetadataToMap(fileMetadata: AGCStorageMetadata) -> Dictionary<String, Any> {
        var map = Dictionary<String, Any>()
        map["bucket"] = fileMetadata.bucketName
        map["creationTimeMillis"] = fileMetadata.createTime ?? ""
        map["updatedTimeMillis"] = fileMetadata.modifyTime ?? ""
        map["name"] = fileMetadata.name ?? ""
        map["path"] = fileMetadata.path
        map["size"] = fileMetadata.size
        map["sha256Hash"] = fileMetadata.sha256Hash ?? ""
        map["contentType"] = fileMetadata.contentType ?? ""
        map["cacheControl"] = fileMetadata.cacheControl ?? ""
        map["contentDisposition"] = fileMetadata.contentDisposition ?? ""
        map["contentEncoding"] = fileMetadata.contentEncoding ?? ""
        map["contentLanguage"] = fileMetadata.contentLanguage ?? ""
        map["customMetadata"] = fileMetadata.customMetadata ?? Dictionary<String, String>()
        
        return map
    }
    
    static func mapToFileMetadata(fileMetadataMap: Dictionary<String, Any>?) -> AGCStorageMetadata {
        let fileMetadata = AGCStorageMetadata.init()
        if(fileMetadataMap != nil) {
            guard let fileMetadataMap = fileMetadataMap else { return fileMetadata}
            if (fileMetadataMap["contentType"] as? String? != nil) {
                fileMetadata.contentType = fileMetadataMap["contentType"] as! String?
            }
            if (fileMetadataMap["cacheControl"] as? String? != nil) {
                fileMetadata.cacheControl = fileMetadataMap["cacheControl"] as! String?
            }
            if (fileMetadataMap["sha256Hash"] as? String? != nil) {
                fileMetadata.sha256Hash = fileMetadataMap["sha256Hash"] as! String?
            }
            if (fileMetadataMap["contentDisposition"] as? String? != nil) {
                fileMetadata.contentDisposition = fileMetadataMap["contentDisposition"] as! String?
            }
            if (fileMetadataMap["contentEncoding"] as? String? != nil) {
                fileMetadata.contentEncoding = fileMetadataMap["contentEncoding"] as! String?
            }
            if (fileMetadataMap["contentLanguage"] as? String? != nil) {
                fileMetadata.contentLanguage = fileMetadataMap["contentLanguage"] as! String?
            }
            if (fileMetadataMap["customMetadata"] as? Dictionary<String, String>? != nil) {
                fileMetadata.customMetadata = fileMetadataMap["customMetadata"] as! Dictionary<String, String>?
            }
        }
        
        return fileMetadata
    }
    
    static func randomId(_ n: Int) -> String
    {
        let digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var result = ""
        
        for _ in 0..<n {
            result += String(digits.randomElement()!)
        }
        
        return result
    }
    
    static func getUploadTaskFromList(name: String, uploadTaskList: [String: AGCStorageUploadTask]) -> AGCStorageUploadTask? {
        return uploadTaskList[name]
    }
    
    static func getdownloadTaskFromList(name: String, downloadTaskList: [String: AGCStorageDownloadTask]) -> AGCStorageDownloadTask? {
        return downloadTaskList[name]
    }
    
    static func uploadResultToMap(taskState: String, uploadResult: AGCStorageUploadResult) -> [String: Any] {
        var map = Dictionary<String, Any>()
        
        map["taskState"] = taskState
        map["metadata"] = FlutterStorageUtils.fileMetadataToMap(fileMetadata: uploadResult.metadata)
        map["bytesTransferred"] = uploadResult.bytesTransferred
        map["totalByteCount"] = uploadResult.totalByteCount
        
        return map;
    }
    
    static func downloadResultToMap(taskState: String, downloadResult: AGCStorageDownloadResult) -> [String: Any] {
        var map = Dictionary<String, Any>()
        
        map["taskState"] = taskState
        map["bytesTransferred"] = downloadResult.bytesTransferred
        map["totalByteCount"] = downloadResult.totalByteCount
        
        return map;
    }
    
    static func getReference(arguments: Dictionary<String, Any>, storage: AGCStorage) -> AGCStorageReference {


        guard let path = arguments["objectPath"] as? String else { return storage.reference()  }
        return storage.reference(withPath: path)
        
    }
}
