//
//  MapView.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/01/30.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct MapView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var coord: (Double, Double) = (126.9784147, 37.5666805)

    var body: some View {
        ZStack {
            UIMapView(coord: coord).edgesIgnoringSafeArea(.vertical)
        }
        // 알림 위치 허용시 내위치 좌표 설정
        .onAppear {
            locationManager.onAuthorizationGranted = updateMapToCurrentLocation
        }
    }

    private func updateMapToCurrentLocation() {
        if let currentLocation = locationManager.location {
            coord = (currentLocation.longitude, currentLocation.latitude)
        }
    }
}

struct UIMapView: UIViewRepresentable {
    var coord: (Double, Double)

    //지도 View 생성
    func makeUIView(context: Context) -> NMFNaverMapView {
        let naverMapView = NMFNaverMapView()
        // 내 위치 활성화 버튼
        naverMapView.showLocationButton = true
        

        
        return naverMapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let newCoord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: newCoord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        
        return uiView.mapView.moveCamera(cameraUpdate)
    }

}

// 위치 정보를 관리 클래스
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
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
