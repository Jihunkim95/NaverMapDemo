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

    @Binding var myCoord: (Double, Double)
    @ObservedObject var viewModel: PostingViewModel
    
    //이전화면으로 돌아가기
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                UIMapMarkerView(myCoord: $myCoord, markerCoord: $viewModel.markerCoord, location: $viewModel.noticeBoard.noticeLocationName)
                        .edgesIgnoringSafeArea(.all)
                
                    MapMakerExplainView()
                        .frame(height: geometry.size.height * 0.15)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.15)//상단으로
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarBackButtonHidden(true) // 뒤로 가기 버튼 숨기기
                VStack{
                    Text(viewModel.noticeBoard.noticeLocationName)
                    Text("\(viewModel.markerCoord?.lat ?? 11),\(viewModel.markerCoord?.lng ?? 11)")
                }

                    Button(action: {
                        
                        print("선택한 위치: \(viewModel.noticeBoard.noticeLocationName)")
                        print("위도 경도: \(viewModel.noticeBoard.noticeLocation)")
                        
                        dismiss()
                    }) {
                        Text("선택완료")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex:"59AAE0"))
                            .cornerRadius(10)

                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.08) // 버튼의 크기를 설정합니다.
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.91) // 하단에 위치
                    .padding(.bottom, geometry.safeAreaInsets.bottom) // 하단 세이프 에어리어만큼 패딩 추가

            }

        }

    }
    

}

struct UIMapMarkerView: UIViewRepresentable {
    @Binding var myCoord: (Double, Double)
    @Binding var markerCoord: NMGLatLng?
    @Binding var location: String

    // View 생성
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView()
        
        mapView.mapView.touchDelegate = context.coordinator
        
        // 내 위치 활성화 버튼
        mapView.showLocationButton = true
        // 초기 카메라 위치 줌
        let cameraUpdate: NMFCameraUpdate
        
        // 마커가 업
        if let cameraCoord = markerCoord {
            cameraUpdate = NMFCameraUpdate(scrollTo: cameraCoord, zoomTo: 15)
        }else {
            cameraUpdate = NMFCameraUpdate(scrollTo:NMGLatLng(lat: myCoord.1, lng: myCoord.0), zoomTo: 15)
        }
        
        mapView.mapView.moveCamera(cameraUpdate)
        return mapView
    }
    
    // View 변경시 호출
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        
            let newMyCoord = NMGLatLng(lat: myCoord.1, lng: myCoord.0)
            let cameraUpdate = NMFCameraUpdate(scrollTo: newMyCoord)
            cameraUpdate.animation = .fly
            cameraUpdate.animationDuration = 1
        //uiView.mapView.moveCamera(cameraUpdate)

        // Maker좌표 변경
        if let coord = markerCoord {
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
            parent.markerCoord = latlng
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
                    
                    //도로명 및 좌표값 API
                    DispatchQueue.main.async {
                        self.parent.location = [seeDo, seeGunGu, dong, gil, landNumber, landValue].joined(separator: " ")
                        self.parent.markerCoord = NMGLatLng(lat: position.lat, lng: position.lng)
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
            task.resume()
        }
    }
}


