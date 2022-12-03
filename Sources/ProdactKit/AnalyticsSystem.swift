//
//  AnalyticsSystem.swift
//  WordixProject
//  Main protocol for Analytics system wrapper
//
//  Created by Iurii Poluektov on 12/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation

/// Protocol for handling operations on UserProperties for analytics system
public protocol AnalyticsUserPropertiesInput {
    
    /**
    Adds properties that are tracked on the user level.
     
    ## Note ##
    Use flat model for parametres where values are convertable to String for best result.

     ### Example of model: ###
    ````
    struct BaseProperties: Codable {
     
        var yearOfFirstLaunch: String
     
        enum CodingKeys: String, CodingKey {
            case yearOfFirstLaunch = "year_of_first_launch"
        }
     }
     
    ````
    
    - Parameters:
        - model: A model conforms to Codable, containing any additional data to be tracked.
    */
    func setUserPropertiesWithModel<T: Codable>(_ model: T)
    
    /**
    Adds properties that are tracked on the user level.
     
    ## Note ##
    Use flat dictionary for parametres where values are convertable to String
     
    - Parameters:
        - dictionary: An Dictionary containing any additional data to be tracked.
    */
    func setUserPropertiesWithDictionary(_ dictionary: [String: Any])
    
    /**
     Sets the value of a given user property. If the value already exists, it will be overwritten with the new value. (See Note)
     ## Note ##
     You can set mutablity property in UserPropertyKey to **.ummutable** then this
     will work like 'Once' and wont override first value of property.
     **(For 12.06.2019 Work only in Amplitude)**
     
     - Parameters:
        - value: String convertible type
        - key: Key described as static let in UserProperyKey
     
     ### Example of creation Keys: ###
     ````
     extension AnalyticsUserPropertyKeys {
        static let ummutableProperty = UserPropertyKey<String>("umutable_property", mutability: .unmutable)
        static let mutableProperty = UserPropertyKey<Int>("mutable_property")
     }
     ````
     */
    func set<T>(value: T, key: UserPropertyKey<T>) where T : LosslessStringConvertible
    
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
    func add<T>(value: T, key: UserPropertyKey<T>) where T : LosslessStringConvertible
    
    /**
     Unset and remove user property. This user property will no longer show up in that user's profile.
     
     ### Example of creation Keys: ###
     ````
     extension AnalyticsUserPropertyKeys {
        static let purchaseCounter = UserPropertyKey<Int>("counter")
     }
     ````
     
     - Parameters:
        - key:The user property key to unset. Key described as static let in UserProperyKey.
     
     */
    func unset(key: UserPropertyKey<Int>)
    
    /**
     Clears all properties that are tracked on the user level.
     
     ## Note ##
     For 12.06.2019 work only in Amplitude and the result is irreversible!
     */
    func clearUserProperties()
}

/// Protocol for handling operations on Events for analytics system
public protocol AnalyticsEventsInput {
    
    /**
    Tracks an event without model ofr parameters.
     
    ## Note ##
    Use **EmtpyEvent** model for event without properties but for strong event typisation.
     
    ### Example of Keys: ###
    ````
    extension AnalyticsEventKeys {
        static let mainSearchTap = EventsKeys<EmptyEvent>("Main search tap")
    }
    ````
     
    - Parameters:
        - eventKey :The user property key. Key described as static let in **xAnalyticsEventKeys**.
     
    */
    func logEvent(_ eventKey: EventKey<EmptyEvent>)
    
    /**
    Tracks an event with model of parameters.
     
     ## Note ##
     Use **BaseEvent** model for event with primiteve properties like String, Int, Bool, etc.
     
     ### Example of Keys: ###
     ````
     extension AnalyticsEventKeys {
        static let eventWithParameters = EventKey<MyParam>("Event with parameters")
        static let eventWithBool = EventKey<BaseEvent<Bool>>("Event with bool")
     }
     ````
     
     - Parameters:
        - eventKey: The user property key. Key described as static let in **AnalyticsEventKeys**.
        - propertiesModel: Model for describing parameters of event.
     
    */
    func logEvent<T>(_ eventKey: EventKey<T>, propertiesModel: T) where T: Encodable
    
    /**
     Tracks an event with model of parameters.
     
     ## Note ##
     Use **BaseEvent** model for event with primiteve properties like String, Int, Bool, etc.
     
     ### Example of Keys: ###
     ````
     extension AnalyticsEventKeys {
        static let eventWithParameters = EventKey<MyParam>("Event with parameters")
        static let eventWithBool = EventKey<BaseEvent<Bool>>("Event with bool")
     }
     ````
     
     - Parameters:
        - eventKey: The user property key. Key described as static let in **AnalyticsEventKeys**.
        - propertiesModel: Model for describing parameters of event.
        - outOfSession: If YES, will track the event as out of session. Useful for push notification events. (**Work only in Amplitude for 12.06.2019**)
     
     */
    func logEvent<T>(_ eventKey: EventKey<T>, propertiesModel: T, outOfSession: Bool) where T: Encodable
}


/// Common protocol for Analytics wrapper
public protocol AnalyticsSystem {
    
    /// Use it for managing of user traits in analytics wrapper.
    var userTraitsInput: AnalyticsUserPropertiesInput { get }
    
    /// Use it for event managment in analytics wrapper.
    var eventInput: AnalyticsEventsInput { get }
    
    /**
    Add event handler implementation fro Analytics wrapper
     
    ## Note ##
    Use it before configureAll method!
    
     - Parameters:
        - handler: Implementation of **AnalyticEventHandler**
     
    */
    func addEventHandler(_ handler: AnalyticEventHandler)
    
    /**
    Add User properties handler implementation fro Analytics wrapper
     
    ## Note ##
    Use it before configureAll method!
     
     - Parameters:
        - handler: Implementation of **AnalyticsUserPropertiesHandler**
     
     */
    func addUserPropertiesHandler(_ handler: AnalyticsUserPropertiesHandler)
    
    /// Must be used only once after addin all analytics system
    func configureAll()
}

extension AnalyticsSystem where Self: AnalyticsEventsInput & AnalyticsUserPropertiesInput {
    public var userTraitsInput: AnalyticsUserPropertiesInput { return self }
    public var eventInput: AnalyticsEventsInput { return self }
}
