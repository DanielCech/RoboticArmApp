//
//  OpkixError.swift
//  Opkix
//
//  Created by Dan Cech on 26.04.2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation

/// Description of Opkix error states
public enum ArmError: Swift.Error {

    case unknownError

    // Bluetooth errors
    case serviceDiscoveryError(Error)
    case characteristicDiscoveryError(Error)
    case deviceConnectError(Error)
    case deviceDisconnectError(Error)

}
