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
    @State var rocation: String? = ""
    
    var body: some View {
        ZStack {
            UIMapMarkerView(coord: coord, touchCoord: $touchCoord, rocation: $rocation)
                .edgesIgnoringSafeArea(.all)
            Text(rocation ?? "")
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
    @Binding var rocation: String?

    // View 생성
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
    
    // View 변경시 호출
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
            // 마커 도로명 주소 불러오기
            fetchAddressForPosition(position)
        }
        private func fetchAddressForPosition(_ position: NMGLatLng) {

            // Reverse Geocoding 요청 및 처리 로직
            // URL, API 키, Request 구성 생략 (보안 및 가독성을 위해)
            print("마커 좌표 : \(position.lat),\(position.lng)")

            guard let url = URL(string: "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(position.lng),\(position.lat)&orders=roadaddr&output=json") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("z5abdsw588", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
            request.addValue("WRgNOFM7oMJTgyj3vYryrOG95LAPsqzswafXff6a", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // JSON 데이터를 디코딩 ㄱㄱ
                do {
                    
                    let decodedData = try JSONDecoder().decode(NaverReverseGeocoding.self, from: data)
                    // 주소 Custom
                    guard let result = decodedData.results?.first else
                    { return print(" decodedData 결과값 없음 ") }
                    let seeDo = result.region.area1.name
                    let seeGunGu = result.region.area2.name
                    let dong = result.region.area3.name
                    let gil = result.land.name
                    let landNumber = result.land.number1
                    let landValue = result.land.addition0.value

//                    dump( result )
                    DispatchQueue.main.async {
                        self.parent.rocation = [seeDo, seeGunGu, dong, gil, landNumber, landValue].joined(separator: " ")
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
            task.resume()
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

struct NaverReverseGeocoding: Codable {
    let status: Status
    let results: [Result]?
}


// 상태 정보
struct Status: Codable {
    let code: Int
    let name: String
    let message: String
}

// 결과 리스트
struct Result: Codable {
    let name: String
    let code: Code
    let region: Region
    let land: Land
}

// 코드 정보
struct Code: Codable {
    let id: String
    let type: String
    let mappingId: String
}

// 지역 정보
struct Region: Codable {
    let area0, area1, area2, area3, area4: Area
}

// 구체적인 지역 단위
struct Area: Codable {
    let name: String
    let coords: Coords
    let alias: String?
    
    struct Coords: Codable {
        let center: Center
    }
    
    struct Center: Codable {
        let crs: String
        let x, y: Double
    }
}

// 토지 정보
struct Land: Codable {
    let type, number1, number2, name: String
    let addition0, addition1, addition2, addition3, addition4: Addition
    let coords: LandCoords
    
    struct Addition: Codable {
        let type: String
        let value: String
    }
    
    struct LandCoords: Codable {
        let center: Center
    }
    
    struct Center: Codable {
        let crs: String
        let x, y: Double
    }
}
