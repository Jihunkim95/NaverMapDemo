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
    @ObservedObject var locationManager = NaverLocationManager()
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
        
        // 초기 카메라 위치 줌
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: coord.1, lng: coord.0), zoomTo: 15)
        
        naverMapView.mapView.moveCamera(cameraUpdate)
        
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
