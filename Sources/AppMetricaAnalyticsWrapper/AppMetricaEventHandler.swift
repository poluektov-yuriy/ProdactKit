import Foundation
import ProdactKit
import AppMetricaCore
import OSLog

@available(iOS 14.0, *)
private let logger = Logger(subsystem: "Analytics", category: "AppMetricaEventHandler")

@available(iOS 14.0, *)
public class AppMetricaEventHandler: AnalyticEventHandler {

   private let apiKey: String

   public init(apiKey: String) {
      self.apiKey = apiKey
   }

   public func configure() {
      if let configuration = AppMetricaConfiguration(apiKey: apiKey) {
         AppMetrica.activate(with: configuration)
      }
   }

   public func logEvent(_ eventType: String) {
      AppMetrica.reportEvent(name: eventType) { error in
         logger.log(">>> ERROR Logging AppMetrica event: \(eventType), error = \(error)")
      }
   }

   public func logEvent(_ eventType: String, properties: [String : Any], outOfSession: Bool) {
      AppMetrica.reportEvent(name: eventType, parameters: properties) { error in
         logger.log(">>> ERROR Logging AppMetrica event: \(eventType), properties: \(String(describing: properties)), error = \(error)")
      }
   }
}

@available(iOS 14.0, *)
extension AppMetricaEventHandler: AnalyticsUserPropertiesHandler {

   // MARK: User Properties

   public func setUserProperties(_ properties: [String : Any]) {
      let profile = MutableUserProfile()
      var profileUpdates: [UserProfileUpdate] = []

      for (key, value) in properties {
         if let stringValue = value as? String {
            profileUpdates.append(ProfileAttribute.customString(key).withValue(stringValue))
         } else if let boolValue = value as? Bool {
            profileUpdates.append(ProfileAttribute.customBool(key).withValue(boolValue))
         } else if let numberValue = value as? NSNumber {
            profileUpdates.append(ProfileAttribute.customNumber(key).withValue(numberValue.doubleValue))
         } else if let intValue = value as? Int {
            profileUpdates.append(ProfileAttribute.customNumber(key).withValue(Double(intValue)))
         } else if let doubleValue = value as? Double {
            profileUpdates.append(ProfileAttribute.customNumber(key).withValue(doubleValue))
         } else {
            let stringValue = String(describing: value)
            profileUpdates.append(ProfileAttribute.customString(key).withValue(stringValue))
         }
      }

      profile.apply(from: profileUpdates)

      AppMetrica.reportUserProfile(profile, onFailure: { error in
         logger.log(">>> ERROR Setting AppMetrica user properties: \(properties), error = \(error.localizedDescription)")
      })
   }

   public func clearUserProperties() {
      logger.log(">>> WARNING: clearUserProperties() is not fully supported in AppMetrica. Properties need to be unset individually.")
   }

   public func set<T>(value: T, key: UserPropertyKey<T>) where T : LosslessStringConvertible {
      let profile = MutableUserProfile()
      let stringValue = String(value)

      if let doubleValue = Double(stringValue) {
         switch key.mutability {
         case .unmutable:
            profile.apply(ProfileAttribute.customNumber(key.key).withValueIfUndefined(doubleValue))
         default:
            profile.apply(ProfileAttribute.customNumber(key.key).withValue(doubleValue))
         }
      } else {
         switch key.mutability {
         case .unmutable:
            profile.apply(ProfileAttribute.customString(key.key).withValueIfUndefined(stringValue))
         default:
            profile.apply(ProfileAttribute.customString(key.key).withValue(stringValue))
         }
      }

      AppMetrica.reportUserProfile(profile, onFailure: { error in
         logger.log(">>> ERROR Setting AppMetrica user property: \(key.key) = \(stringValue), error = \(error.localizedDescription)")
      })
   }

   public func add<T>(value: T, key: UserPropertyKey<T>) where T : LosslessStringConvertible {
      let profile = MutableUserProfile()

      let stringValue = String(value)
      if let doubleValue = Double(stringValue) {
         profile.apply(ProfileAttribute.customCounter(key.key).withDelta(doubleValue))
      } else {
         logger.log(">>> WARNING: AppMetrica add() only supports numeric values. Key: \(key.key), Value: \(stringValue)")

         profile.apply(ProfileAttribute.customCounter(key.key).withDelta(0))
      }

      AppMetrica.reportUserProfile(profile, onFailure: { error in
         logger.log(">>> ERROR Adding AppMetrica user property: \(key.key) += \(stringValue), error = \(error.localizedDescription)")
      })
   }

   public func unset<T>(key: UserPropertyKey<T>) where T : LosslessStringConvertible {
      let profile = MutableUserProfile()

      profile.apply(from: [
         ProfileAttribute.customString(key.key).withValueReset(),
         ProfileAttribute.customNumber(key.key).withValueReset(),
         ProfileAttribute.customBool(key.key).withValueReset(),
      ])

      AppMetrica.reportUserProfile(profile, onFailure: { error in
         logger.log(">>> ERROR Unsetting AppMetrica user property: \(key.key), error = \(error.localizedDescription)")
      })
   }
}
