//
//  APIRequest.swift
//  Salon
//
//  Created by Alex Demerjian on 7/31/22.
//

import Foundation
import CryptoKit
import UIKit
import SwiftUI
import Network
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let data = OSLog(subsystem: "Network", category: "errorData")
}

class Network{
    
    let baseURL: String = "https://www.grex.com/art/"
    
    static let shared = Network()
    
    //MARK: - Login
    func login(username: String, password: String) async -> Result<NewUser, Error>{
        
        //verify that the network is connected
        if getNetworkStatus() == .satisfied {
           
            //convert password to sha256
            let passwordData = Data(password.utf8)
            var sha256Password = SHA256.hash(data: passwordData).description
            //get only the hashed password part of the string return by the sha256 hash
            sha256Password = String(sha256Password.suffix(64))
            
            //create body of request
            let body: [String: String] = ["login":username, "pwd":sha256Password]
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            
            guard let resourceURL = URL(string: baseURL + Resource.login.rawValue)else{return .failure(ClientError.resourceURLError)}
            
            //prepare url request object
            var request = URLRequest(url: resourceURL)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            
            //set request headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //perform https request and handle response
            do{
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                let httpResponse = response as? HTTPURLResponse
                
                // ensure there is valid response code returned from this HTTP response
                guard (200...299).contains(httpResponse!.statusCode) else{
                    //if there is not a valid response code returned, then record the error/response code in the log and return response code error
                    os_log("Error Logging In. Response Code Error: Invalid response code %{public}@.", log: OSLog.data, type: .error, httpResponse!.statusCode)
                    
                    return .failure(ResponseError.responseCodeError)
                }
                
                //try to convert the response data to a json
                var json: [String: Any] = [:]
                do{
                    json = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])!
                    
                }catch{
                    
                    //if the data failed to convert to json, return a json conversion error and log the details
                    os_log("Failed to convert the data from the login response to JSON.", log: OSLog.data, type: .error)
                    
                    return .failure(ResponseError.jsonConversionError)
                }
                
                //if the json response is empty, return a data error and log the details
                if json.isEmpty{
                    os_log("The login response data was converted to JSON, but the JSON is empty.", log: OSLog.data, type: .error)
                    return .failure(ResponseError.dataError)
                    
                }else{
                    
                    //else check if the json response contains a key for error
                    if json.keys.contains("error"){
                        
                        if json["error"] as! Int == -1{
                            os_log("The user entered incorrect credentials and could not be logged in.", log: OSLog.data, type: .error)
                            return .failure(AccountError.incorrectCredentials)
                            
                        }else if json["error"] as! Int == -2{
                            
                            os_log("The account the user is attempting to login to has been banned.", log: OSLog.data, type: .error)
                            return .failure(AccountError.accountBanned)
                            
                        }else{
                            
                            os_log("An unknown error occurred.", log: OSLog.data, type: .error)
                            return .failure(ResponseError.unknownError)
                        }
                        
                    }else{
                        
                        //otherwise, decode the json response into the newUser observable object
                        let newUser: NewUser = try! JSONDecoder().decode(NewUser.self, from: data)
                        return .success(newUser)
                    }
                }
                
            }catch{
                return .failure(error)
            }
            
            
        }else{
            
            //log the details of the error
            os_log("No internet connection.", log: OSLog.data, type: .error)
            //return failure with no internet error
            return .failure(NetworkError.noInternet)
             
        }
    }
    
    //MARK: - Logout
    func logout() async -> Result<String, Error>{
        
        //if there is an internet connection, continue with the request
        if getNetworkStatus() == .satisfied{
            
            //create body of request
            let body: [String: String] = [:]
            let finalBody = try? JSONSerialization.data(withJSONObject: body)
            
            guard let resourceURL = URL(string: baseURL + Resource.logout.rawValue)else{return .failure(ClientError.resourceURLError)}
            
            //prepare url request object
            var request = URLRequest(url: resourceURL)
            request.httpMethod = "POST"
            request.httpBody = finalBody
            
            //set request headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            do{
                
                //perform https request
                let (data, response) = try await URLSession.shared.data(for: request)
                
                let httpResponse = response as? HTTPURLResponse
                
                // ensure there is valid response code returned from this HTTP response
                guard (200...299).contains(httpResponse!.statusCode)else{
                    //if there is not a valid response code returned, then record the error/response code in the log and return response code error
                    os_log("Error Logging Out. Response Code Error: Invalid response code %{public}@.", log: OSLog.data, type: .error, httpResponse!.statusCode)
                    return .failure(ResponseError.responseCodeError)
                }
                
                //convert the data to a string
                let dataString = String(decoding: data, as: UTF8.self)
                
                //if the string is empty, return with success
                if dataString == ""{
                    
                    return .success("")
                    
                }else{
                    
                    os_log("Error Logging Out. Unexpected data received from server: %{public}@", log: OSLog.data, type: .error, dataString)
                    return .failure(ResponseError.logoutError)
                }
                
            }catch{
                
                return .failure(error)
            }
           
        }else{
            //log the details of the error
            os_log("No internet connection.", log: OSLog.data, type: .error)
            
            //return failure with no internet error
            return .failure(NetworkError.noInternet)
        }
        
        
        
    }
    
    //MARK: - Get Image
    func getImage(sessionID: String, contentID: Int, random: Int) async -> Result<CompositionCallBack, Error>{
        
        //create body of request
        let body: [String: Any] = ["Panalee":sessionID, "random":random, "CID":contentID]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        guard let resourceURL = URL(string: baseURL + Resource.getImage.rawValue)else{return .failure(ClientError.resourceURLError)}
        
        //prepare url request object
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        request.httpBody = finalBody
                
        //set request headers
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.addValue("image/jpeg", forHTTPHeaderField: "Accept")
        
        //if there is an internet connection, continue with the request
        if getNetworkStatus() == .satisfied{
            
            do{
                
                //perform https request and handle response
                let (data, response) = try await URLSession.shared.data(for: request)
                
                let httpResponse = response as? HTTPURLResponse
                
                // ensure there is valid response code returned from this HTTP response
                guard (200...299).contains(httpResponse!.statusCode)else{
                    
                    //if there is not a valid response code returned, then record the error/response code in the log and return response code error
                    os_log("Error Getting Image. Response Code Error: Invalid response code %{public}@.", log: OSLog.data, type: .error, httpResponse!.statusCode)
                    
                    return .failure(ResponseError.responseCodeError)
                }
                
                //if the image is not null, success and return the image
                if let uiImage = UIImage(data: data){
                    
                    let compositionCallBack = CompositionCallBack(image: Image(uiImage: uiImage), contentID: contentID, message: "")
                    return .success(compositionCallBack)
                    
                }else{
                    
                    //otherwise attempt to convert the response to a string
                    let imageResponseString = String(decoding: data, as: UTF8.self)
                    
                    //if the string is empty, set message to "Couldn't fetch the image" and return the composition call back
                    if imageResponseString.isEmpty == true{
                        
                        let compositionCallBack = CompositionCallBack(image: Image(systemName: "camera.metering.unknown"), contentID: contentID, message: "Couldn't fetch the image")
                        return .success(compositionCallBack)
                        
                    }else{
                        
                        //if the string is not empty, set the message to it and return the composition call back
                        let compositionCallBack = CompositionCallBack(image: Image(systemName: "camera.metering.unknown"), contentID: contentID, message: imageResponseString)
                        return .success(compositionCallBack)
                    }
                }
                
            }catch{
                
                return .failure(error)
            }
            
        }else{
            
            //log the details of the error
            os_log("No internet connection.", log: OSLog.data, type: .error)
            //return failure with no internet error
            return .failure(NetworkError.noInternet)
        }
        
    }
    
    /*
    //MARK: - Get User Content List
    func getUserContentList(sessionID: String, uID: Int, sort: String) async -> Result<[String:Any], Error>{
        
        //create body of request
        let body: [String: Any] = ["Panalee":sessionID, "uid":uID, "sort":sort]
        let finalBody = try? JSONSerialization.data(withJSONObject: body)
        
        
        //prepare url request object
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        //set request headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //if there is an internet connection, continue with the request
        if getNetworkStatus() == .satisfied{
            
            //perform https request and handle response
            do{
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                let httpResponse = response as? HTTPURLResponse
                
                // ensure there is valid response code returned from this HTTP response
                guard (200...299).contains(httpResponse!.statusCode) else{
                    
                    return .failure(ResponseError.responseCodeError)
                }
                
                //try to convert the response data to a json
                var jsonResponse: [String: Any] = [:]
                do{
                    
                    jsonResponse = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])!
                    
                    //if the json response is empty, return a data problem
                    if jsonResponse.isEmpty{
                        
                        return .failure(ResponseError.dataError)
                        
                    }else{
                        
                        print(jsonResponse)
                        return .success(jsonResponse)
                    }
                    
                }catch{
                    
                    //if the data failed to convert to json, return a decoding problem
                    return .failure(ResponseError.jsonDecodingError)
                }
                
                
            }catch{
                
                return .failure(error)
            }
            
        }else{
            
            //log the details of the error
            os_log("No internet connection.", log: OSLog.data, type: .error)
            //return failure with no internet error
            return .failure(NetworkError.noInternet)
        }
        
    }
    */
    
    //MARK: - Upload Image
    func uploadImage(sessionID: String, imageName: String, image: UIImage, compositionTitle: String, compositionDescription: String, compositionForAdults: Bool, compositionPrivate: Bool) async -> Result<String, Error>{
        
        //declare tags for each section of the form
        let tag1 = "key"
        let tag2 = "title"
        let tag3 = "description"
        let tag4 = "adult"
        let tag5 = "private"
        let tag6 = "fileToUpload"
        
        //add extension to imageName
        let imageNameWithExtension = imageName + ".jpg"
        
        //convert compositionForAdults from bool to string
        var stringCompositionForAdults = ""
        if compositionForAdults == false{
            
            stringCompositionForAdults = "0"
            
        }else{
            
            stringCompositionForAdults = "1"
        }
        
        
        //convert compositionPrivate from bool to string
        var stringCompositionPrivate = ""
        
        if compositionPrivate == false{
            
            stringCompositionPrivate = "0"
            
        }else{
            
            stringCompositionPrivate = "1"
        }
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        guard let resourceURL = URL(string: baseURL + Resource.uploadImage.rawValue)else{return .failure(ClientError.resourceURLError)}
        
        //prepare url request object
        var request = URLRequest(url: resourceURL)
        request.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("key", forHTTPHeaderField: sessionID)
        
        var data = Data()
        
        //append session id to form data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(tag1)\";".data(using: .utf8)!)
        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        data.append(sessionID.data(using: .utf8)!)
        
        //append title of composition to form data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(tag2)\";".data(using: .utf8)!)
        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        data.append(compositionTitle.data(using: .utf8)!)
        
        //append description of composition to form data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(tag3)\";".data(using: .utf8)!)
        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        data.append(compositionDescription.data(using: .utf8)!)
        
        //append chosen adult status of composition to form data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(tag4)\";".data(using: .utf8)!)
        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        data.append(stringCompositionForAdults.data(using: .utf8)!)
        
        //append chosen private status of composition to form data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(tag5)\";".data(using: .utf8)!)
        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        data.append(stringCompositionPrivate.data(using: .utf8)!)
        
        //append fileToUpload tag, image name and image to form data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(tag6)\"; filename=\"\(imageNameWithExtension)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.1)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        
        //if there is an internet connection, continue with the request
        if getNetworkStatus() == .satisfied{
            
            //perform https request and handle response
            do{
                
                let (data, response) = try await URLSession.shared.upload(for: request, from: data)
                
                let httpResponse = response as? HTTPURLResponse
                
                // ensure there is valid response code returned from this HTTP response
                guard (200...299).contains(httpResponse!.statusCode) else{
                    
                    return .failure(ResponseError.responseCodeError)
                }
                
                //try to convert the response data to a string
                let uploadDataString = String(decoding: data, as: UTF8.self)
                
                return .success(uploadDataString)
                
            }catch{
                return .failure(error)
            }
        }else{
            
            //log the details of the error
            os_log("No internet connection.", log: OSLog.data, type: .error)
            //return failure with no internet error
            return .failure(NetworkError.noInternet)
        }
        
    }
    
    //Getcontentcomments.php

    
    //MARK: - Get Network Status
    func getNetworkStatus() -> NWPath.Status{
        
        //create a network monitor
        let networkMonitor = NWPathMonitor()
        
        //start monitoring the network on the global queue
        networkMonitor.start(queue: .global())

        //get the current network path
        let networkPath = networkMonitor.currentPath
        
        //cancel the current network monitor
        networkMonitor.cancel()
        
        return NWPath.Status.satisfied
    }
}
