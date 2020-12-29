//
//  IDXClientError+Extensions.swift
//  okta-idx-ios
//
//  Created by Mike Nachbaur on 2020-12-17.
//

import Foundation

extension IDXClientError: Equatable {
    public static func ==(lhs: IDXClientError, rhs: IDXClientError) -> Bool {
        switch (lhs, rhs) {
        case (.stateHandleMissing, .stateHandleMissing): return true
        case (.invalidClient, .invalidClient): return true
        case (.cannotCreateRequest, .cannotCreateRequest): return true
        case (.invalidHTTPResponse, .invalidHTTPResponse): return true
        case (.invalidResponseData, .invalidResponseData): return true
        case (.invalidRequestData, .invalidRequestData): return true
        case (.serverError(message: let lhsMessage, localizationKey: let lhsLocalizationKey, type: let lhsType),
              .serverError(message: let rhsMessage, localizationKey: let rhsLocalizationKey, type: let rhsType)):
            return (lhsMessage == rhsMessage && lhsLocalizationKey == rhsLocalizationKey && lhsType == rhsType)
        case (.invalidParameter(name: let lhsName), .invalidParameter(name: let rhsName)):
            return lhsName == rhsName
        case (.invalidParameterValue(name: let lhsName), .invalidParameterValue(name: let rhsName)):
            return lhsName == rhsName
        case (.parameterImmutable(name: let lhsName), .parameterImmutable(name: let rhsName)):
            return lhsName == rhsName
        case (.missingRequiredParameter(name: let lhsName), .missingRequiredParameter(name: let rhsName)):
            return lhsName == rhsName
        case (.unknownRemediationOption(name: let lhsName), .unknownRemediationOption(name: let rhsName)):
            return lhsName == rhsName
        case (.successResponseMissing, .successResponseMissing): return true
        default:
            return false
        }
    }
}

extension IDXClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .stateHandleMissing:
            return NSLocalizedString("State handle missing.",
                                     comment: "Error message thrown when an IDX state handle is missing.")
        case .invalidClient:
            return NSLocalizedString("IDXClient instance is invalid.",
                                     comment: "Error message thrown when an IDXClient object is missing or becomes invalid.")
        case .cannotCreateRequest:
            return NSLocalizedString("Could not create a URL request for this action.",
                                     comment: "Error message thrown when an error occurs while creating a URL request.")
        case .invalidHTTPResponse:
            return NSLocalizedString("Response received from a URL request is invalid.",
                                     comment: "Error message thrown when a network response has an invalid type or status code.")
        case .invalidResponseData:
            return NSLocalizedString("Response data is invalid or could not be parsed.",
                                     comment: "Error message thrown when response data is invalid.")
        case .invalidRequestData:
            return NSLocalizedString("Request data is invalid or could not be parsed.",
                                     comment: "Error message thrown when request data is invalid.")
        case .serverError(message: let message, localizationKey: let localizationKey, type: _):
            let result = NSLocalizedString(localizationKey, comment: "Error message thrown from the server.")
            guard result != localizationKey else {
                return message
            }
            return result
        case .invalidParameter(name: let name):
            return NSLocalizedString("Invalid parameter \"\(name)\" supplied to a remediation option.",
                                     comment: "Error message thrown when an invalid parameter is supplied.")
        case .invalidParameterValue(name: let name, type: let type):
            return NSLocalizedString("Parameter \"\(name)\" was supplied a \(type) value which is unsupported.",
                                     comment: "Error message thrown when an invalid parameter value is supplied.")
        case .parameterImmutable(name: let name):
            return NSLocalizedString("Cannot override immutable remediation parameter \"\(name)\".",
                                     comment: "Error message thrown when a value is passed to an immutable parameter.")
        case .missingRequiredParameter(name: let name):
            return NSLocalizedString("Required parameter \"\(name)\" missing.",
                                     comment: "Error message thrown when a required value is missing.")
        case .unknownRemediationOption(name: let name):
            return NSLocalizedString("Unknown remediation option \"\(name)\".",
                                     comment: "Error message thrown when a remediation option is invoked that doesn't exist.")
        case .successResponseMissing:
            return NSLocalizedString("Success response is missing or unavailable.",
                                     comment: "Error message thrown when a success response is not yet ready.")
        }
    }
}

extension IDXClientError: CustomNSError {
    public static var errorDomain: String {
        return "IDXClientError"
    }
    
    public var errorCode: Int {
        switch self {
        case .invalidClient: return 1
        case .stateHandleMissing: return 2
        case .cannotCreateRequest: return 3
        case .invalidHTTPResponse: return 4
        case .invalidResponseData: return 5
        case .invalidRequestData: return 6
        case .serverError(message: _, localizationKey: _, type: _): return 7
        case .invalidParameter(name: _): return 8
        case .invalidParameterValue(name: _, type: _): return 9
        case .parameterImmutable(name: _): return 10
        case .missingRequiredParameter(name: _): return 11
        case .unknownRemediationOption(name: _): return 12
        case .successResponseMissing: return 13
        }
    }

    public var errorUserInfo: [String : Any] {
        switch self {
        case .invalidClient: fallthrough
        case .stateHandleMissing: fallthrough
        case .cannotCreateRequest: fallthrough
        case .invalidHTTPResponse: fallthrough
        case .invalidResponseData: fallthrough
        case .invalidRequestData: fallthrough
        case .successResponseMissing:
            return [:]
        case .serverError(message: let message, localizationKey: let localizationKey, type: let type):
            return [
                "message": message,
                "type": type,
                "localizationKey": localizationKey
            ]
        case .invalidParameter(name: let name):
            return [
                "name": name
            ]
        case .invalidParameterValue(name: let name, type: let type):
            return [
                "name": name,
                "type": type
            ]
        case .parameterImmutable(name: let name):
            return [
                "name": name
            ]
        case .missingRequiredParameter(name: let name):
            return [
                "name": name
            ]
        case .unknownRemediationOption(name: let name):
            return [
                "name": name
            ]
        }
    }
}
