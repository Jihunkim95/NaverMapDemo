//
//  MapView.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/01/30.
//

import SwiftUI
import NMapsMap

struct MapView: View{
    var body: some View {
        ZStack {
            UIMapView()
                .edgesIgnoringSafeArea(.vertical)
        }
    }
}


struct UIMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFNaverMapView {
        // NMFMapView의 인스턴스 생성
        let view = NMFNaverMapView()
//        view.showZoomControls = false
//        view.mapView.positionMode = .direction
//        view.mapView.zoomLevel = 17
        view.frame = .zero
      
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
    
}
