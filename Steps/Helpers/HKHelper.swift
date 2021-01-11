//
//  HKHelper.swift
//  Stepper
//
//  Created by Nikita Pekurin on 6.01.21.
//

import HealthKit
import Foundation

public class HKHelper {

    private let hkStore: HKHealthStore
    private let hkTypes: Set = [HKSampleType.quantityType(forIdentifier: .stepCount)!]
    
    public var hasAccess = false
    
    private(set) static var shared: HKHelper? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHelper()
        } else {
            return nil
        }
    }()
    
    private init() {
        hkStore = HKHealthStore()
    }
    
    func getStepsCount(completion: @escaping (HKStatisticsQuery, HKStatistics?, Error?) -> Void) {
        let hkStepsType = HKSampleType.quantityType(forIdentifier: .stepCount)!
        
        let date = Date()
        let dateDayBeginning = Calendar.current.startOfDay(for: date)
        
        let hkPredicate = HKQuery.predicateForSamples(withStart: dateDayBeginning,
                                                    end: date,
                                                    options: .strictStartDate)
        
        let hkQuery = HKStatisticsQuery(quantityType: hkStepsType,
                                        quantitySamplePredicate: hkPredicate,
                                        options: .cumulativeSum,
                                        completionHandler: completion)
        
        
        hkStore.execute(hkQuery)
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        hkStore.requestAuthorization(toShare: hkTypes, read: hkTypes) { [weak self] (bool, error) in
            self?.hasAccess = bool
            completion(bool)
        }
    }
    
    func getRequestStatus(completion: @escaping (Bool) -> Void) {
        hkStore.getRequestStatusForAuthorization(toShare: hkTypes, read: hkTypes) { (status, error) in
            completion(status != .shouldRequest)
        }
    }
}
