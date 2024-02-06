//
//  LocationManager.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/05.
//

import Foundation
import CoreLocation

// NaverMap API 위치 정보허용 관리 클래스
class NaverLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    var onAuthorizationGranted: (() -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate
        onAuthorizationGranted?()
    }
}
