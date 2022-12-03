//
//  AmplitudeEventHandler.swift
//  WordixProject
//
//  Created by Iurii Poluektov on 07/06/2019.
//  Copyright © 2019 Entertech. All rights reserved.
//

import Foundation
import ProdactKit
import Amplitude

public class AmplitudeEventHandler: AnalyticEventHandler {
     
    private var _isConfigured = false
    private let amplitude = Amplitude.instance()
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - Configure
    public func configure() {
        if _isConfigured == false {
            amplitude.initializeApiKey(apiKey)
            _isConfigured = true
        }
    }
    
    // MARK: - Events

    public func logEvent(_ eventType: String) {
        amplitude.logEvent(eventType)
    }
    
    public func logEvent(_ eventType: String, properties: [String: Any], outOfSession: Bool) {
        amplitude.logEvent(eventType, withEventProperties: properties, outOfSession: outOfSession)
    }
}

extension AmplitudeEventHandler: AnalyticsUserPropertiesHandler {

    // MARK: User Properties

    public func setUserProperties(_ properties: [String : Any]) {
        amplitude.setUserProperties(properties)
    }
    
    public func clearUserProperties() {
        amplitude.clearUserProperties()
    }

    public func set<T: LosslessStringConvertible> (value: T, key: UserPropertyKey<T>) {
        let identify = AMPIdentify()
        let stringValue = String(value)
        switch key.mutability {
        case .unmutable:
            identify.setOnce(key.key, value: NSString(string: stringValue))
        default:
            identify.set(key.key, value: NSString(string: stringValue))
        }
        amplitude.identify(identify)
    }
    
    public func add<T: LosslessStringConvertible>(value: T, key: UserPropertyKey<T>) {
        let identify = AMPIdentify()
        let stringValue = String(value)
        identify.add(key.key, value: NSString(string: stringValue))
        amplitude.identify(identify)
    }

    public func unset<T>(key: UserPropertyKey<T>) where T : LosslessStringConvertible {
        let identify = AMPIdentify()
        identify.unset(key.key)
        amplitude.identify(identify)
    }
}
