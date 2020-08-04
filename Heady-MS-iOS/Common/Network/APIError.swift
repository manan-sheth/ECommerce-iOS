//
//  APIError.swift
//  Heady-MS-iOS
//
//  Created by Manan Sheth on 02/08/20.
//  Copyright © 2020 Manan Sheth. All rights reserved.
//

import Foundation

//MARK:- Error Protocol
protocol ErrorProtocol: Error {
      
      var localizedTitle: String { get }
      var localizedDescription: String? { get }
      var requestedAPI: String { get }
      var code: Int { get }
}

//MARK:- Custom Error
struct APICustomError: ErrorProtocol {
      
      var localizedTitle: String
      var localizedDescription: String?
      var requestedAPI: String
      var code: Int
      
      /**
       Initialize Error Object.
       
       - Parameter title: Error Title
       - Parameter desc: Error Description
       - Parameter code: Error Code
       - Parameter api: API endpoint in which error is thrown
       */
      init(title: String?, desc: String? = nil, code: Int, api: String) {
            
            self.localizedTitle = title ?? "Error"
            self.code = code
            self.requestedAPI = api
            
            if let msg = desc, msg.count > 0 {
                  self.localizedDescription = msg
            }
            else {
                  self.localizedDescription = getHTTPErrorMessage(status: 200)
            }
      }
      
      //MARK:- Error Messages
      /**
       Creates a standardized error message.
       
       - Parameter status: HTTP status code
       
       - Returns: A error description string will be returned.
       */
      func getHTTPErrorMessage(status: Int) -> String {
            
            var strMessage: String = ""
            
            switch status {
                  
            //Server Errors
            case 400:
                  strMessage = "The server cannot or will not process the request due to an apparent client error."
            case 401:
                  strMessage = "Authentication is required and has failed or has not yet been provided."
            case 402:
                  strMessage = "Authentication Required."
            case 403:
                  strMessage = "The request was valid, but the server is refusing action. The user might not have the necessary permissions for a resource."
            case 404:
                  strMessage = "The requested resource could not be found but may be available in the future. Subsequent requests by the client are permissible."
            case 500:
                  strMessage = "A generic error message, given when an unexpected condition was encountered and no more specific message is suitable."
            case 502:
                  strMessage = "The server was acting as a gateway or proxy and received an invalid response from the upstream server."
            case 503:
                  strMessage = "The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state."
                  
            //URL Errors
            case NSURLErrorUnknown:
                  strMessage = "An unknown error occurred. Please try again in a while."
            case NSURLErrorCancelled:
                  strMessage = "The connection was cancelled. Please try again in a while."
            case NSURLErrorBadURL:
                  strMessage = "The connection failed due to a malformed URL. Please try again in a while."
            case NSURLErrorTimedOut:
                  strMessage = "Looks like you have an unstable network at the moment. Please try again in a while."
            case NSURLErrorUnsupportedURL:
                  strMessage = "The connection failed due to an unsupported URL scheme. Please try again in a while."
            case NSURLErrorCannotFindHost:
                  strMessage = "The connection failed because the host could not be found. Please try again in a while."
            case NSURLErrorCannotConnectToHost:
                  strMessage = "The connection failed because a connection cannot be made to the host. Please try again in a while."
            case NSURLErrorNetworkConnectionLost:
                  strMessage = "The connection failed because the network connection was lost. Please try again in a while."
            case NSURLErrorDNSLookupFailed:
                  strMessage = "The connection failed because the DNS lookup failed. Please try again in a while."
            case NSURLErrorHTTPTooManyRedirects:
                  strMessage = "The HTTP connection failed due to too many redirects. Please try again in a while."
            case NSURLErrorResourceUnavailable:
                  strMessage = "The connection’s resource is unavailable. Please try again in a while."
            case NSURLErrorNotConnectedToInternet:
                  strMessage = "The connection failed because the device is not connected to the internet. Please try again in a while."
            case NSURLErrorRedirectToNonExistentLocation:
                  strMessage = "The connection was redirected to a nonexistent location. Please try again in a while."
            case NSURLErrorBadServerResponse:
                  strMessage = "The connection received an invalid server response. Please try again in a while."
            case NSURLErrorUserCancelledAuthentication:
                  strMessage = "The connection failed because the user cancelled required authentication. Please try again in a while."
            case NSURLErrorUserAuthenticationRequired:
                  strMessage = "The connection failed because authentication is required. Please try again in a while."
            case NSURLErrorZeroByteResource:
                  strMessage = "The resource retrieved by the connection is zero bytes. Please try again in a while."
            case NSURLErrorCannotDecodeRawData:
                  strMessage = "The connection cannot decode data encoded with a known content encoding. Please try again in a while."
            case NSURLErrorCannotDecodeContentData:
                  strMessage = "The connection cannot decode data encoded with an unknown content encoding. Please try again in a while."
            case NSURLErrorCannotParseResponse:
                  strMessage = "The connection cannot parse the server’s response. Please try again in a while."
            case NSURLErrorAppTransportSecurityRequiresSecureConnection:
                  strMessage = "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection. Please try again in a while."
            case NSURLErrorFileDoesNotExist:
                  strMessage = "The file operation failed because the file does not exist. Please try again in a while."
            case NSURLErrorFileIsDirectory:
                  strMessage = "The file operation failed because the file is a directory. Please try again in a while."
            case NSURLErrorNoPermissionsToReadFile:
                  strMessage = "The file operation failed because it does not have permission to read the file. Please try again in a while."
            case NSURLErrorDataLengthExceedsMaximum:
                  strMessage = "The file operation failed because the file is too large. Please try again in a while."
                  
            //SSL Errors
            case NSURLErrorSecureConnectionFailed:
                  strMessage = "The secure connection failed for an unknown reason. Please try again in a while."
            case NSURLErrorServerCertificateHasBadDate:
                  strMessage = "The secure connection failed because the server’s certificate has an invalid date. Please try again in a while."
            case NSURLErrorServerCertificateUntrusted:
                  strMessage = "The secure connection failed because the server’s certificate is not trusted. Please try again in a while."
            case NSURLErrorServerCertificateHasUnknownRoot:
                  strMessage = "The secure connection failed because the server’s certificate has an unknown root. Please try again in a while."
            case NSURLErrorServerCertificateNotYetValid:
                  strMessage = "The secure connection failed because the server’s certificate is not yet valid. Please try again in a while."
            case NSURLErrorClientCertificateRejected:
                  strMessage = "The secure connection failed because the client’s certificate was rejected. Please try again in a while."
            case NSURLErrorClientCertificateRequired:
                  strMessage = "The secure connection failed because the server requires a client certificate. Please try again in a while."
            case NSURLErrorCannotLoadFromNetwork:
                  strMessage = "The connection failed because it is being required to return a cached resource, but one is not available. Please try again in a while."
                  
            //Download and file I/O Errors
            case NSURLErrorCannotCreateFile:
                  strMessage = "The file cannot be created. Please try again in a while."
            case NSURLErrorCannotOpenFile:
                  strMessage = "The file cannot be opened. Please try again in a while."
            case NSURLErrorCannotCloseFile:
                  strMessage = "The file cannot be closed. Please try again in a while."
            case NSURLErrorCannotWriteToFile:
                  strMessage = "The file cannot be written. Please try again in a while."
            case NSURLErrorCannotRemoveFile:
                  strMessage = "The file cannot be removed. Please try again in a while."
            case NSURLErrorCannotMoveFile:
                  strMessage = "The file cannot be moved. Please try again in a while."
            case NSURLErrorDownloadDecodingFailedMidStream:
                  strMessage = "The download failed because decoding of the downloaded data failed mid-stream. Please try again in a while."
            case NSURLErrorDownloadDecodingFailedToComplete:
                  strMessage = "The download failed because decoding of the downloaded data failed to complete. Please try again in a while."
                  
            case NSURLErrorInternationalRoamingOff:
                  strMessage = "The connection failed because international roaming is disabled on the device. Please try again in a while."
            case NSURLErrorCallIsActive:
                  strMessage = "The connection failed because a call is active. Please try again in a while."
            case NSURLErrorDataNotAllowed:
                  strMessage = "The connection failed because data use is currently not allowed on the device. Please try again in a while."
            case NSURLErrorRequestBodyStreamExhausted:
                  strMessage = "The connection failed because its request’s body stream was exhausted. Please try again in a while."
                  
            //Background Session Errors
            case NSURLErrorBackgroundSessionRequiresSharedContainer:
                  strMessage = "Background session required shared container at the moment. Please try again in a while."
            case NSURLErrorBackgroundSessionInUseByAnotherProcess:
                  strMessage = "Background session is in use by another network process at the moment. Please try again in a while."
            case NSURLErrorBackgroundSessionWasDisconnected:
                  strMessage = "Background session disconnected. Please try again in a while."
                  
            default:
                  strMessage = "Looks like you have an unstable network at the moment. Please try again in a while."
            }
            return strMessage
      }
}
