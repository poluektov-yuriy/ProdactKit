//
//  AnalyticsUserPropertiesHandler.swift
//  WordixProject
//
//  Created by Iurii Poluektov on 12/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation

public protocol AnalyticsUserPropertiesHandler {
    
    /// Use configure for systems witch don't have implementatin for AnalyticsEventHandler
    func configure()
    
    /**
     Adds properties that are tracked on the user level.
     
     ## Note ##
     Use only flat dictionary for parametres where values are convertable to String
     
     - Parameters:
        - properties: An Dictionary containing any additional data to be tracked.
    */
    func setUserProperties(_ properties: [String: Any])
    
    /**
     Clears all properties that are tracked on the user level.
     
     ## Note ##
     For 12.06.2019 work only in Amplitude and the result is irreversible!
    */
    func clearUserProperties()
    
    /**
    Sets the value of a given user property. If the value already exists, it will be overwritten with the new value. (See Note)
     ## Note ##
     You can set mutablity property in UserPropertyKey to **.ummutable** then this
     will work like 'Once' and wont override first value of property.
     **(For 12.06.2019 Work only in Amplitude)**
     
     ### Example of creation Keys: ###
     ````
     extension AnalyticsUserPropertyKeys {
        static let ummutableProperty = UserPropertyKey<String>("umutable_property", mutability: .unmutable)
        static let mutableProperty = UserPropertyKey<Int>("mutable_property")
     }
     ````
     
     - Parameters:
       - value: String convertible type
       - key: Key described as static let in UserProperyKey
    */
    func set<T: LosslessStringConvertible> (value: T, key: UserPropertyKey<T>)
    
    /**
     Increment a user property by a given value (can also be negative to decrement).
     
     If the user property does not have a value set yet, it will be initialized to 0 before being incremented.
     
     ## Note ##
     **(For 12.06.2019 Work only in Amplitude)**
     
     ### Example of creation Keys: ###
     ````
     extension AnalyticsUserPropertyKeys {
        static let purchaseCounter = UserPropertyKey<Int>("counter")
     }
     ````
     
     - Parameters:
        - value: String convertible type. The amount by which to increment the user property.
        - key: Key described as static let in UserProperyKey
     
     */
    func add<T: LosslessStringConvertible>(value: T, key: UserPropertyKey<T>)
    
    /**
     Unset and remove user property. This user property will no longer show up in that user's profile.
     
     ### Example of creation Keys: ###
     ````
     extension AnalyticsUserPropertyKeys {
        static let purchaseCounter = UserPropertyKey<Int>("counter")
     }
     ````
     
     - Parameters:
        - key: The user property key to unset. Key described as static let in UserProperyKey
     
     */
    func unset<T: LosslessStringConvertible>(key: UserPropertyKey<T>)
}

extension AnalyticsUserPropertiesHandler {
    // Declare it becaus I don't have any other systmes for clearing all properties in systems. Except Amplitude.
    func clearUserProperties() {}
}


