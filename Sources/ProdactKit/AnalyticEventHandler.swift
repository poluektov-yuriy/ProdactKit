//
//  AnalyticsAction.swift
//  This protocol mus be implemented in analytics system for handling event throught Analytics framework
//
//  Created by Iurii Poluektov on 07/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation

public protocol AnalyticEventHandler {
    
    /// Initial **configure** for analytics system
    func configure()
    
    /// Tracks an event without parameters
    ///
    /// - Parameter eventType: The name of the event you wish to track.
    func logEvent(_ eventType: String)
    
    /**
        Tracks an event with parameters.
     
        ## Note: ##
        outOfSession implemented only in Amplitude system (12.06.2019)
    
        - Parameters:
          - eventType: The name of the event you wish to track.
          - properties: You can attach additional data to any event by passing a NSDictionary object with property: [String: Any]
          - outOfSession: If YES, will track the event as out of session. Useful for push notification events.
    */
    func logEvent(_ eventType: String, properties: [String: Any], outOfSession: Bool)
}
