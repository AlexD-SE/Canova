//
//  Error Handling.swift
//  Demeer
//
//  Created by Alex Demerjian on 7/8/23.
//

import Foundation

enum ClientError: Error, CustomStringConvertible{
    case resourceURLError
    
    public var description: String{
        switch self{
        case .resourceURLError:
            return "Resource URL Error: The Resource URL is invalid."
        }
    }
}

enum ResponseError: Error, CustomStringConvertible{
    case responseCodeError
    case dataError
    case jsonDecodingError
    case jsonConversionError
    case loginError
    case logoutError
    case getImageError
    case unknownError
    
    public var description: String {
        switch self {
        case .responseCodeError:
            return "Response Code Error: Invalid response code from the server."
        case .dataError:
            return "Data Error: The data returned from the server was empty."
        case .jsonDecodingError:
            return "JSON Decoding Error: Could not decode the JSON data from the server into the desired object."
        case .jsonConversionError:
            return "JSON Conversion Error: Failed to convert the data to JSON."
        case .loginError:
            return "Sorry, we ran into an issue logging you in. We know you want to see incredible art."
        case .logoutError:
            return "Sorry, we ran into an issue logging you out. Your art skills are just too good."
        case .getImageError:
            return "Sorry, we couldn't load the compositions."
        case .unknownError:
            return "We ran into an unknown issue. Don't worry, the compositions are still okay."
        }
    }
}


enum NetworkError: Error, CustomStringConvertible{
    case noInternet
    
    public var description: String {
        switch self {
        case .noInternet:
            return "No Internet Connection. Please check your internet settings and try again."
        }
    }
}

enum AccountError: Error, CustomStringConvertible{
    
    case incorrectCredentials
    case accountBanned
    
    public var description: String {
        switch self {
        case .incorrectCredentials:
            return "The username or password is incorrect."
        case .accountBanned:
            return "Account has been banned. Please contact us via support."
        }
    }
}
