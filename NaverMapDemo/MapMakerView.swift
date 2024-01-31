//
//  MapMakerView.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/01/31.
//

import SwiftUI
import NMapsMap
import CoreLocation


struct MapMarkerView: View {
    @ObservedObject var locationManager = LocationManager()
    @State var touchCoord: NMGLatLng? = nil
    @State var coord: (Double, Double) = (126.9784147, 37.5666805)
    var body: some View {
        ZStack {
            UIMapMarkerView(coord: coord, touchCoord: $touchCoord)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            locationManager.onAuthorizationGranted = updateMapToCurrentLocation
        }
    }
    private func updateMapToCurrentLocation() {
        if let currentLocation = locationManager.location {
            coord = (currentLocation.longitude, currentLocation.latitude)
//            print(coord)
        }
    }
}

struct UIMapMarkerView: UIViewRepresentable {
    var coord: (Double, Double)
    @Binding var touchCoord: NMGLatLng?

    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        
        mapView.mapView.touchDelegate = context.coordinator
        
        // 내 위치 활성화 버튼
        mapView.showLocationButton = true
        // 초기 카메라 위치 줌
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coord.1, lng: coord.0), zoomTo: 15)
        
        mapView.mapView.moveCamera(cameraUpdate)
        return mapView
    }

    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let newMyCoord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: newMyCoord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        
        uiView.mapView.moveCamera(cameraUpdate)
        
        if let coord = touchCoord {
            context.coordinator.updateMarkerPosition(coord, on: uiView.mapView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)  // 'self'를 Coordinator에 전달
    }

    class Coordinator: NSObject, NMFMapViewTouchDelegate {
        var parent: UIMapMarkerView
        var marker: NMFMarker? = nil

        init(_ parent: UIMapMarkerView) {
            self.parent = parent
        }

        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            parent.touchCoord = latlng
        }

        func updateMarkerPosition(_ position: NMGLatLng, on mapView: NMFMapView) {
            // 기존 마커 제거
            marker?.mapView = nil

            // 새로운 마커 생성 및 추가
            let newMarker = NMFMarker(position: position)
            newMarker.mapView = mapView
            marker = newMarker
            
            print("마커 좌표 : \(position.lat),\(position.lng)")
            
        }
    }
}


// 위치 정보허용 관리 클래스
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
