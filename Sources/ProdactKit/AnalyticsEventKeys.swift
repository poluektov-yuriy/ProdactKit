//
//  AnalyticsEventKeys.swift
//  WordixProject
//
//  Created by Iurii Poluektov on 07/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation

/// Base helper model for event without parameters
public struct EmptyEvent: Encodable {}

/// Base helper model for primitive types like String, Int, Bool, etc.
public struct BaseEvent<T: Encodable>: Encodable {
    var value: T
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
}

/**
Base class for Event keys. Use extension on it for strong describing keys and parameters for them.
 
 ### Example of usage ###
 ````
 extension AnalyticsEventKeys {
    static let event = EventKey<EmptyEvent>("Main search tap")
    static let eventWithParameters = EventKey<MyParam>("Event with parameters")
    static let eventWithBool = EventKey<BaseEvent<Bool>>("Event with bool")
 }
 
 Analytics.shared.eventInput.logEvent(.event)
 
 Analytics.shared.eventInput.logEvent(.eventWithBool, propertiesModel: BaseEvent(value: true))
 
 Analytics.shared.eventInput.logEvent(.eventWithParameters, propertiesModel: MyParam(test: "My param", value: 10))
 ````
*/
open class AnalyticsEventKeys {}

/// Class for describing keys for Event.
public class EventKey<PropertiesType: Encodable>: AnalyticsEventKeys {
    public let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}

