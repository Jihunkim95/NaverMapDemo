//
//  PostingViewModel.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/05.
//

import Foundation
import NMapsMap


class PostingViewModel: ObservableObject {
    
    @Published var noticeBoard: NoticeBoard
    @Published var markerCoord: NMGLatLng? //사용자가 저장 전에 마커 좌표변경을 할 경우 대비
    
    init() {
        noticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [], noticeLocationName: "교환장소 선택", isChange: false, state: 0, date: Date())
    }
}
