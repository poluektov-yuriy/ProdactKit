//
//  UserPropertyDescriptor.swift
//  WordixProject
//
//  Created by Iurii Poluektov on 10/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation

/**
 Base class for User Property keys. Use extension on it for strong describing properties and parameters for them.
 
 ### Example of usage ###
 ````
 extension AnalyticsUserProperyKeys {
    static let firstLaunch = UserPropertyKey<String>("first_launch_week", mutability: .unmutable)
    static let mutableProperty = UserPropertyKey<String>("mutable_property")
    static let purchaseCounter = UserPropertyKey<Int>("counter")
 }
 
 Analytics.shared.userTraitsInput.set(value: "2017.20", key: .firstLaunch)
 
 Analytics.shared.userTraitsInput.set(value: "Turn on", key: .mutableProperty)
 
 Analytics.shared.userTraitsInput.add(value: 2, key: .purchaseCounter)
 
 ````
 */
open class AnalyticsUserPropertyKeys {}

/**
Traits of property for setting in once or override it every time.
 
 ````
 case unmutable
 case mutable
 
 ````
    - unmutable: Set property only once
    - mutable: Override property every time
*/
public enum PropertyMutability {
    /// Set property only once
    case unmutable
    /// Override property every time (default)
    case mutable
}

/// Class for describing keys for User Property.
public class UserPropertyKey<ValueType: LosslessStringConvertible>: AnalyticsUserPropertyKeys {
    
    public let key: String
    public let mutability: PropertyMutability
    
    public init(_ key: String, mutability: PropertyMutability = .mutable) {
        self.key = key
        self.mutability = mutability
    }
}
