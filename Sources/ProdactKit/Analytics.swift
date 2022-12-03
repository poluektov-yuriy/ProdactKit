//
//  Analytics.swift
//  WordixProject
//
//  Created by Iurii Poluektov on 07/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation

public class Analytics: AnalyticsSystem {
    
    private var eventHandlers: [AnalyticEventHandler] = []
    private var userPropertiesHandlers: [AnalyticsUserPropertiesHandler] = []
    
    // MARK: Singleton
    
    private static let _shared = Analytics()
    
    public class var eventInput: AnalyticsEventsInput {
        return _shared
    }

    public class var userTraitsInput: AnalyticsUserPropertiesInput {
        return _shared
    }
    
    public class var shared: AnalyticsSystem {
        return _shared
    }
    
    private init() {}
    
    // MARK: Configuration
    
    public func addEventHandler(_ handler: AnalyticEventHandler) {
        eventHandlers.append(handler)
    }
    
    public func addUserPropertiesHandler(_ handler: AnalyticsUserPropertiesHandler) {
        userPropertiesHandlers.append(handler)
    }
    
    public func configureAll() {
        eventHandlers.forEach { $0.configure() }
        userPropertiesHandlers.forEach { $0.configure() }
    }
}

extension Analytics: AnalyticsEventsInput {
    
    // MARK: Events

    public func logEvent<T: Encodable>(_ eventKey: EventKey<T>) {
        eventHandlers.forEach { $0.logEvent(eventKey.key) }
    }
    
    public func logEvent<T>(_ eventKey: EventKey<T>, propertiesModel: T) where T : Encodable {
        logEvent(eventKey, propertiesModel: propertiesModel, outOfSession: false)
    }
    
    public func logEvent<T: Encodable>(_ eventKey: EventKey<T>, propertiesModel: T, outOfSession: Bool = false) {
        let encoder = DictionaryEncoder()
        do {
            let properties: [String: Any] = try encoder.encode(propertiesModel)
            eventHandlers.forEach { $0.logEvent(eventKey.key, properties: properties, outOfSession: outOfSession) }
        } catch {
            fatalError("Error! Encoding for model of user propery. \(propertiesModel)")
        }
    }
}

extension Analytics: AnalyticsUserPropertiesInput {
    
    // MARK: User Properties
    
    public func setUserPropertiesWithModel<T: Codable>(_ model: T) {
        let encoder = DictionaryEncoder()
        do {
            let properties: [String: Any] =  try encoder.encode(model)
            userPropertiesHandlers.forEach { $0.setUserProperties(properties) }
        } catch {
            fatalError("Error! Encoding for model of user propery. \(model)")
        }
    }
    
    public func setUserPropertiesWithDictionary(_ dictionary: [String: Any]) {
        userPropertiesHandlers.forEach { $0.setUserProperties(dictionary) }
    }
    
    public func clearUserProperties() {
        userPropertiesHandlers.forEach { $0.clearUserProperties() }
    }

    public func set<T>(value: T, key: UserPropertyKey<T>) where T : LosslessStringConvertible {
        userPropertiesHandlers.forEach { $0.set(value: value, key: key) }
    }
    
    public func add<T>(value: T, key: UserPropertyKey<T>) where T : LosslessStringConvertible {
        userPropertiesHandlers.forEach { $0.add(value: value, key: key) }
    }
    
    public func unset(key: UserPropertyKey<Int>) {
        userPropertiesHandlers.forEach { $0.unset(key: key) }
    }
}
